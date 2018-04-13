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
  end
end
