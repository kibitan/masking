# frozen_string_literal: true

require 'masking/config/target_columns'
require 'masking/insert_statement'

module Masking
  # TODO: find better naming/modeling of DataMaskProcessor
  class DataMaskProcessor
    def initialize(insert_statement_line, target_columns: ::Masking.config.target_columns)
      @raw_line         = insert_statement_line
      @target_columns   = target_columns
      @insert_statement = InsertStatement.new(insert_statement_line)
    end

    # TODO: define insert_statement.mask_values(column, mask_method) method & refactoring
    # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    def process
      return raw_line unless target_table?

      columns = target_columns.columns(table_name: insert_statement.table)
      if columns.first.index.nil?
        columns.each do |target_column|
          target_column.index = insert_statement.columns.index(target_column.name)
        end
      end

      insert_statement.values.each do |values|
        columns.each do |target_column|
          values[target_column.index] = target_column.masked_value unless target_column.index.nil?
        end
      end

      insert_statement.sql
    end
    # rubocop:enable Metrics/AbcSize,Metrics/MethodLength

    def target_table?
      target_columns.contains?(table_name: insert_statement.table)
    end

    private

    attr_reader :raw_line, :target_columns, :insert_statement
  end
end
