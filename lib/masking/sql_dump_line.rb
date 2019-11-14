# frozen_string_literal: true

require 'masking/data_mask_processor'

module Masking
  class SQLDumpLine
    def initialize(line, mask_processor: DataMaskProcessor)
      @line = line
      @mask_processor = mask_processor
    end

    def output
      insert_statement? ? mask_processor.process(line) : line
    end

    private

    attr_reader :line, :mask_processor
    INSERT_STATEMENT_REGEXP = /^INSERT/.freeze

    def insert_statement?
      line.match?(INSERT_STATEMENT_REGEXP)
    end
  end
end
