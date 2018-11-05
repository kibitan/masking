# frozen_string_literal: true

require 'masking/data_mask_processor'

module Masking
  class SQLDumpLine
    def initialize(line)
      @line = line
    end

    def output
      insert_statement? ? DataMaskProcessor.process(line) : line
    end

    private

    attr_reader :line
    INSERT_STATEMENT_REGEXP = /^INSERT/

    def insert_statement?
      line.match?(INSERT_STATEMENT_REGEXP)
    end
  end
end
