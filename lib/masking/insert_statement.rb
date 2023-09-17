# frozen_string_literal: true

require 'masking/errors'
require 'masking/insert_statement/sql_builder'

module Masking
  class InsertStatement
    attr_reader :raw_statement, :table

    def initialize(raw_statement, sql_builder: SQLBuilder)
      @raw_statement = raw_statement
      @sql_builder = sql_builder

      PARSE_REGEXP.match(raw_statement).tap do |match_data|
        raise Error::InsertStatementParseError if match_data.nil?

        @table           = match_data[:table]
        @columns_section = match_data[:columns_section]
        @values_section  = match_data[:values_section]
      end
    end

    def columns
      @columns ||= columns_section.scan(COLUMNS_REGEXP).flatten.map(&:to_sym)
    end

    def column_index(column_name)
      columns.index(column_name)
    end

    def values
      @values ||= values_section.split(VALUE_ROW_SPLITTER)
                                .tap { |rows| rows.each_with_index { |_, i| recursive_pattern_value_concat!(rows, i) } }
                                # `rows.count.time` doesn't work as rows can be destructively change (change the size of rows) inside of #ecursive_pattern_value_concat!
                                .flat_map { |row| row.scan(values_regexp) }
    end

    def mask_value(column_index:, mask_method:)
      values.each do |value|
        value[column_index] = mask_method.call(value[column_index])
      end
    end

    def sql
      sql_builder.new(table: table, columns: columns, values: values).sql
    end

    private

    attr_reader :columns_section, :values_section, :sql_builder

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
      @values_regexp ||= /^\(?#{([VALUE_REGEXP] * columns.count).join(?,)}\)?$/
    end

    # Check single quote count on each value, and just continue if it's even number.
    # if it's odd, concat with next row (it means a value contains "),(" pattern)
    #   e.g. INSERT ... VALUES (123,'string ),( abc'),(456,'ab');
    # refs: implementation of parsing CSV on ruby standard library FasterCSV (ja): https://www.clear-code.com/blog/2018/12/25.html
    def recursive_pattern_value_concat!(value_rows, index)
      return if value_rows[index].gsub(/\\\\/, '').gsub(/\\'/, '').count(?').even?

      # make destructive change for values_rows
      value_rows[index] += VALUE_ROW_SPLITTER + value_rows.delete_at(index + 1)
      recursive_pattern_value_concat!(value_rows, index)
    end
  end
end
