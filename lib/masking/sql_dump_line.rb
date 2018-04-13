module Masking
  class SQLDumpLine
    def initialize(line)
      @line = line
    end

    def output
      line
    end

    private

    attr_reader :line

    DATALINE_REGEXP = /^INSERT/
    def data_line?
      line.match?(DATALINE_REGEXP)
    end
  end
end
