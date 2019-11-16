# frozen_string_literal: true

require 'masking/config/target_columns/method'

module Masking
  class Config
    class TargetColumns
      class Column
        attr_reader :name, :table_name, :method_value, :method, :index

        def initialize(name, table_name:, method_value:)
          raise ColumnNameIsNil if name.nil?

          @name         = name.to_sym
          @table_name   = table_name.to_sym
          @method_value = method_value
          @method       = Method.new(method_value)
        end

        def ==(other)
          name == other.name && table_name == other.table_name && method_value == other.method_value
        end

        def store_index_by_insert_statement(insert_statement)
          @index = insert_statement.column_index(name)
        end

        class ColumnNameIsNil < StandardError; end
      end
    end
  end
end
