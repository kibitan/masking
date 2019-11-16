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

      columns = target_columns.columns(table_name: insert_statement.table)
      if columns.first.index.nil?
        columns.each do |target_column|
          target_column.store_index_by_insert_statement(insert_statement)
        end
      end

      columns.each do |target_column|
        next if target_column.index.nil?

        insert_statement.mask_value(
          column_index: target_column.index,
          mask_method: target_column.method
        )
      end

      insert_statement.sql
    end

    def target_table?
      target_columns.contains?(table_name: insert_statement.table)
    end

    private

    attr_reader :raw_line, :target_columns, :insert_statement
  end
end
