# frozen_string_literal: true

require 'masking/data_mask_processor/cache'
require 'masking/config/target_columns'
require 'masking/insert_statement'

module Masking
  class DataMaskProcessor
    def initialize(
      insert_statement_line,
      target_columns: ::Masking.config.target_columns,
      insert_statement: InsertStatement.new(insert_statement_line),
      cache_store: Cache
    )
      @raw_line         = insert_statement_line
      @target_columns   = target_columns
      @insert_statement = insert_statement
      @cache_store      = cache_store
    end

    def process
      return raw_line unless target_table?

      column_indexes_mask_methods.each do |column_index, mask_method|
        next if column_index.nil?

        insert_statement.mask_value(
          column_index: column_index,
          mask_method: mask_method
        )
      end

      insert_statement.sql
    end

    private

    attr_reader :raw_line, :target_columns, :insert_statement, :cache_store

    def target_table?
      target_columns.contains?(table_name: table_name)
    end

    def column_indexes_mask_methods
      cache_store.fetch_or_store_if_no_cache(
        table: table_name,
        proc: proc {
          target_columns.columns(table_name: table_name).map do |column|
            [insert_statement.column_index(column.name), column.method]
          end
        }
      )
    end

    def table_name
      @table_name = insert_statement.table
    end
  end
end
