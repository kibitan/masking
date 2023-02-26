# frozen_string_literal: true

require 'masking/data_mask_processor'

module Masking
  class SQLDumpLine
    def initialize(line, mask_processor: DataMaskProcessor)
      @line = line
      @mask_processor = mask_processor
    end

    def mask
      processor.new(line).process
    end

    def insert_statement?
      line.match?(INSERT_STATEMENT_REGEXP)
    end

    private

    attr_reader :line, :mask_processor

    INSERT_STATEMENT_REGEXP = /^INSERT/.freeze

    def processor
      insert_statement? ? mask_processor : NoMaskProcessor
    end

    class NoMaskProcessor
      def initialize(line)
        @line = line
      end

      def process
        @line # do nothing
      end
    end
  end
end
