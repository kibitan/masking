# frozen_string_literal: true

require 'masking/config/target_columns'
require 'masking/insert_statement'

module Masking
  class DataMaskProcessor
    def initialize(
      insert_statement_line,
      target_columns: ::Masking.config.target_columns,
      insert_statement: InsertStatement.new(insert_statement_line)
    )
      @raw_line         = insert_statement_line
      @target_columns   = target_columns
      @insert_statement = insert_statement
    end

    def process
      return raw_line unless target_table?

      store_indexes_in_target_columns
      mask_values
      insert_statement.sql
    end

    def target_table?
      target_columns.contains?(table_name: insert_statement.table)
    end

    private

    def store_indexes_in_target_columns
      return unless columns.first.index.nil?

      columns.each do |target_column|
        target_column.index = insert_statement.column_index(target_column.name)
      end
    end

    def mask_values
      columns.each do |target_column|
        next if target_column.index.nil?

        insert_statement.mask_value(
          column_index: target_column.index,
          mask_method: target_column.method
        )
      end
    end

    def columns
      @columns ||= target_columns.columns(table_name: insert_statement.table)
    end

    attr_reader :raw_line, :target_columns, :insert_statement
  end
end
