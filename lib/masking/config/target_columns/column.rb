# frozen_string_literal: true

require 'masking/config/target_columns/method'

module Masking
  module Config
    class TargetColumns
      class Column
        attr_reader :name, :table_name, :method_value

        def initialize(name, table_name:, method_value:)
          @name         = name.to_sym
          @table_name   = table_name.to_sym
          @method_value = method_value
          @method       = Method.new(method_value)
        end

        def masked_value
          method.call
        end

        def ==(other)
          name == other.name && table_name == other.table_name && method_value == other.method_value
        end

        private

        attr_reader :method
      end
    end
  end
end
