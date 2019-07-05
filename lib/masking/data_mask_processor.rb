# frozen_string_literal: true

require 'masking/config/target_columns'
require 'masking/insert_statement'

module Masking
  # TODO: find better naming/modeling of DataMaskProcessor
  class DataMaskProcessor
    class << self
      def process(insert_statement_line, target_columns: ::Masking.config.target_columns)
        new(insert_statement_line, target_columns: target_columns).send(:process)
      end
    end

    private

    attr_reader :raw_line, :target_columns, :insert_statement

    def initialize(insert_statement_line, target_columns:)
      @raw_line         = insert_statement_line
      @target_columns   = target_columns
      @insert_statement = InsertStatement.new(insert_statement_line, target_columns)
    end

    # TODO: define insert_statement.mask_values(column, mask_method) method & refactoring
    # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    def process
      return raw_line unless target_table?
      insert_statement.sql
    end
    # rubocop:enable Metrics/AbcSize,Metrics/MethodLength

    def target_table?
      target_columns.contains?(table_name: insert_statement.table)
    end
  end
end
