# frozen_string_literal: true

require 'masking/config/target_columns/method'

module Masking
  class Config
    class TargetColumns
      class Column
        attr_reader :table_name, :method_value, :method

        def initialize(name, table_name:, method_value:)
          raise ColumnNameIsNil if name.nil?

          @original_name = name.to_sym
          @table_name    = table_name.to_sym
          @method_value  = method_value
          @method        = Method.new(method_value)
        end

        def ==(other)
          name == other.name && table_name == other.table_name && method_value == other.method_value
        end

        def name
          @name ||= ignore_null? ? original_name.to_s.chomp(IGNORE_NULL_SUFFIX).to_sym : original_name
        end

        def ignore_null?
          @ignore_null ||= original_name.to_s.end_with?(IGNORE_NULL_SUFFIX)
        end

        class ColumnNameIsNil < StandardError; end

        private

        attr_reader :original_name

        IGNORE_NULL_SUFFIX = '?'
      end
    end
  end
end
