module Masking
  class DataLine
    attr_reader :raw_line, :table_name

    def initialize(raw_line)
      @raw_line = raw_line
      PARSE_REGEXP.match(raw_line).tap do |match_data|
        @table_name = match_data[:table_name]
      end
    end

    def mask
    end

    private
    PARSE_REGEXP = /INSERT INTO `(?<table_name>.+)` /
  end
end
