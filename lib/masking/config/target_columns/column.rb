module Masking
  module Config
    class TargetColumns
      class Column
        attr_reader :name, :table

        def initialize(name, table:, method:)
          @name   = name.to_sym
          @table  = table
          @method = method.to_s
        end

        def method
          # TODO: this is temporary implementation, this should be different/flexible class
          -> { @method }
        end

        def ==(other)
          name == other.name && table == other.table && method.call == other.method.call
        end
      end
    end
  end
end
