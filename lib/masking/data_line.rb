module Masking
  class DataLine
    attr_reader :raw_line, :table_name

    def initialize(raw_line)
      @raw_line = raw_line
      PARSE_REGEXP.match(raw_line).tap do |match_data|
        @table_name   = match_data[:table_name]
        @columns_data = match_data[:columns_data]
      end
    end

    def mask
    end

    def columns
      @columns ||= columns_data.split(', ').map { |str| str.tr('`', '') }
    end

    private
    attr_reader :columns_data
    PARSE_REGEXP = /INSERT INTO `(?<table_name>.+)` \((?<columns_data>.+)\) /
  end
end
