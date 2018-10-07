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
      @values ||= values_section.scan(values_regexp).map { |data| Value.new(columns: columns, data: data) }
    end

    def sql
      SQLBuilder.build(table: table, columns: columns, values: values)
    end

    private

    attr_reader :columns_section, :values_section
    PARSE_REGEXP = /INSERT INTO `(?<table>.+)` \((?<columns_section>.+)\) VALUES (?<values_section>.+);/
    COLUMNS_REGEXP = /`(.*?)`/
    # NOTE:
    #   in mysqldump, integer/float/NULL type has dumped without single quote. e.g. -123 / 2.4 / NULL
    #   string/time type has dumped with single quote. e.g. 'string' / '2018-08-22 13:27:34'
    #   if there is single quote inside of value, it will dumped with escape. e.g. 'chikahiro\'s item'
    VALUE_REGEXP = "([0-9.-]+|'.*?'|NULL)"

    def values_regexp
      /\(#{([VALUE_REGEXP] * columns.count).join(?,)}\),?/
    end
  end
end
