# frozen_string_literal: true

require 'masking/insert_statement/value'
require 'masking/insert_statement/sql_builder'

module Masking
  class InsertStatement
    attr_reader :raw_statement, :table

    def initialize(raw_statement)
      @raw_statement = raw_statement

      PARSE_REGEXP.match(raw_statement).tap do |match_data|
        @table           = match_data[:table]
        @columns_section = match_data[:columns_section]
        @values_section  = match_data[:values_section]
      end
    end

    def columns
      # NOTE: define and extract to ColumnSet class?
      @columns ||= columns_section.scan(COLUMNS_REGEXP).flatten.map(&:to_sym)
    end

    def values
      # NOTE: define and extract to ValueSet class?
      @values ||= values_section.split(VALUE_ROW_SPLITTER)
                                .tap { |rows| rows.each_with_index { |_, i| recursive_pattern_value_concat(rows, i) } }
                                .map { |row| row.scan(values_regexp).flatten }
                                .map { |data| Value.new(columns: columns, data: data) }
    end

    def sql
      SQLBuilder.build(table: table, columns: columns, values: values)
    end

    private

    attr_reader :columns_section, :values_section

    VALUE_ROW_SPLITTER = '),('
    PARSE_REGEXP = /INSERT INTO `(?<table>.+)` \((?<columns_section>.+)\) VALUES (?<values_section>.+);/.freeze
    COLUMNS_REGEXP = /`(.*?)`/.freeze

    # NOTE: in mysqldump,
    #   integer/float/NULL type has dumped without single quote. e.g. -123 / 2.4 / NULL
    #   string/time type has dumped with single quote. e.g. 'string' / '2018-08-22 13:27:34'
    #   binary/blob type has dumped with _binary prefix. e.g. _binary 'binarydata'
    #   if there is single quote inside of value, it will dumped with escape. e.g. 'chikahiro\'s item'
    #   in number, there could be include Scientific notation e.g. 1.2E3 / -1.2E-3 / 1e+030 / 9.71726e-17
    #     refs: https://dev.mysql.com/doc/refman/5.7/en/precision-math-numbers.html
    NUMBER_REGEXP      = '[+eE0-9.-]+'
    NULL_REGEXP        = 'NULL'
    STRING_TIME_REGEXP = "'.*?'"
    BINARY_REGEXP      = "_binary '.*?'"

    VALUE_REGEXP = "(#{NUMBER_REGEXP}|#{NULL_REGEXP}|#{STRING_TIME_REGEXP}|#{BINARY_REGEXP})"

    def values_regexp
      /^\(?#{([VALUE_REGEXP] * columns.count).join(?,)}\)?$/
    end

    # Check single quote count on each value, and just continue if it's even number.
    # if it's odd, concat with next row (it means a value contains "),(" pattern)
    #   e.g. INSERT ... VALUES (123,'string ),( abc'),(456,'ab');
    # refs: Ruby 2.6.0とより高速なcsv - ククログ(2018-12-25)]: https://www.clear-code.com/blog/2018/12/25.html
    #   > このようなケースにも対応するために、FasterCSVはline.split(",")した後の各要素のダブルクォートの数を数えます。
    #   > ダブルクォートの数が偶数ならダブルクォートの対応が取れていて、奇数なら取れていないというわけです。
    #   > ダブルクォートの対応が取れていない場合は後続する要素と連結します。
    def recursive_pattern_value_concat(value_rows, index)
      return if value_rows[index].gsub(/\\\\/, '').gsub(/\\'/, '').scan(/'/).count.even?

      value_rows[index] += VALUE_ROW_SPLITTER + value_rows.delete_at(index + 1)
      recursive_pattern_value_concat(value_rows, index)
    end
  end
end
