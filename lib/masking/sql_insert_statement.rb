require "masking/sql_insert_statement/value"

module Masking
  class SQLInsertStatement
    attr_reader :raw_statement, :table_name

    def initialize(raw_statement)
      @raw_statement = raw_statement

      PARSE_REGEXP.match(raw_statement).tap do |match_data|
        @table_name      = match_data[:table_name]
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

    private

    attr_reader :columns_section, :values_section
    PARSE_REGEXP = /INSERT INTO `(?<table_name>.+)` \((?<columns_section>.+)\) VALUES (?<values_section>.+);/
    COLUMNS_REGEXP = /`(.*?)`/

    def values_regexp
      /\(#{(Array("(.*?)") * columns.count).join(?,)}\),?/
    end
  end
end
