require 'masking/config/target_columns'

module Masking
  class SQLInsertStatement
    require 'masking/sql_insert_statement/value'
    attr_reader :raw_statement, :table_name, :target_columns

    def initialize(raw_statement, target_columns: Config::TargetColumns.new)
      @raw_statement  = raw_statement
      @target_columns = target_columns

      PARSE_REGEXP.match(raw_statement).tap do |match_data|
        @table_name      = match_data[:table_name]
        @columns_section = match_data[:columns_section]
        @values_section  = match_data[:values_section]
      end
    end

    def mask
    end

    def columns
      @columns ||= columns_section.scan(COLUMNS_REGEXP).flatten.map(&:to_sym)
    end

    def values
      values_datas.map { |data| Value.new(columns: columns, data: data) }
    end

    def target_table?
      target_columns.contains?(table_name: table_name)
    end

    private
    attr_reader :columns_section, :values_section
    PARSE_REGEXP = /INSERT INTO `(?<table_name>.+)` \((?<columns_section>.+)\) VALUES (?<values_section>.+);/
    COLUMNS_REGEXP = /`(.*?)`/

    def values_datas
      @values_datas ||= values_section.scan(values_regexp)
    end

    def values_regexp
      /\(#{(Array("(.*?)") * columns.count).join(?,)}\),?/
    end
  end
end
