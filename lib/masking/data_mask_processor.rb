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

    attr_reader :raw_line, :target_columns, :insert_statement

    def target_table?
      target_columns.contains?(table_name: insert_statement.table)
    end

    def column_indexes_mask_methods
      Cache.fetch_or_store_if_no_cache(
        insert_statement.table,
        columns.map { |column| [insert_statement.column_index(column.name), column.method] }
      )
    end

    def columns
      @columns ||= target_columns.columns(table_name: insert_statement.table)
    end

    class Cache
      def self.fetch_or_store_if_no_cache(table_name, column_indexes_mask_methods)
        @cache ||= {}

        if @cache.key?(table_name)
          @cache[table_name]
        else
          @cache[table_name] = column_indexes_mask_methods
        end
      end

      def self.clear # only for test
        @cache = {}
      end
    end
  end
end
