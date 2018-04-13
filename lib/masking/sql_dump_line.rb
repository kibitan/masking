require 'masking/data_line'

module Masking
  class SQLDumpLine
    def initialize(line)
      @line = line
    end

    def output
      data_line? ? DataLine.new(line).mask : line
    end

    private

    attr_reader :line

    DATALINE_REGEXP = /^INSERT/
    def data_line?
      line.match?(DATALINE_REGEXP)
    end
  end
end
