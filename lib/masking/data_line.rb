module Masking
  class DataLine
    require 'yaml'
    attr_reader :raw_line, :table_name, :target_columns

    ## TODO: define target_columns to another class
    def initialize(raw_line, target_columns: YAML.load(Pathname('target_columns.yml').read))
      @raw_line = raw_line
      @target_columns = target_columns

      PARSE_REGEXP.match(raw_line).tap do |match_data|
        @table_name   = match_data[:table_name].to_sym
        @columns_data = match_data[:columns_data]
      end
    end

    def mask
    end

    def columns
      @columns ||= columns_data.split(', ').map { |str| str.tr('`', '') }.map(&:to_sym)
    end

    def target_table?
      !!target_columns[table_name]
    end

    private
    attr_reader :columns_data
    PARSE_REGEXP = /INSERT INTO `(?<table_name>.+)` \((?<columns_data>.+)\) /
  end
end
