require 'masking/config/target_columns/method'

module Masking
  module Config
    class TargetColumns
      class Column
        attr_reader :name, :table_name, :method

        def initialize(name, table_name:, method:)
          @name        = name.to_sym
          @table_name  = table_name.to_sym
          @method      = method
        end

        def masked_value
          Method.new(@method).call
        end

        def ==(other)
          name == other.name && table_name == other.table_name && method == other.method
        end
      end
    end
  end
end
