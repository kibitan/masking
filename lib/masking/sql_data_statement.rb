require 'masking/config/target_columns'

module Masking
  class SQLDataStatement
    attr_reader :raw_line, :table_name, :target_columns

    def initialize(raw_line, target_columns: Config::TargetColumns.new)
      @raw_line = raw_line
      @target_columns = target_columns

      PARSE_REGEXP.match(raw_line).tap do |match_data|
        @table_name   = match_data[:table_name]
        @columns_data = match_data[:columns_data]
        @values_data  = match_data[:values_data]
      end
    end

    def mask
    end

    def columns
      @columns ||= columns_data.split(', ').map { |str| str.tr('`', '') }
    end

    def target_table?
      target_columns.contains?(table_name: table_name)
    end

    def values
      @values ||= values_data.scan(values_regexp)
    end

    private
    attr_reader :columns_data, :values_data
    PARSE_REGEXP = /INSERT INTO `(?<table_name>.+)` \((?<columns_data>.+)\) VALUES (?<values_data>.+);/

    def values_regexp
      /\(#{(Array("(.*?)") * columns.count).join(?,)}\),?/
    end
  end
end
