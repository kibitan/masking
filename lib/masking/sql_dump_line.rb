require 'masking/sql_data_statement'

module Masking
  class SQLDumpLine
    def initialize(line)
      @line = line
    end

    def output
      data_line? ? SQLDataStatement.new(line).mask : line
    end

    private

    attr_reader :line

    SQL_DATA_STATEMENT_REGEXP = /^INSERT/
    def data_line?
      line.match?(SQL_DATA_STATEMENT_REGEXP)
    end
  end
end
