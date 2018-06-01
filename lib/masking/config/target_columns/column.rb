module Masking
  module Config
    class TargetColumns
      class Column
        attr_reader :name, :table_name

        def initialize(name, table_name:, method:)
          @name        = name.to_sym
          @table_name  = table_name.to_sym
          @method      = method.to_s
        end

        def method
          # TODO: this is temporary implementation, this should be different/flexible class
          -> { %Q|'#{@method}'| }
        end

        def ==(other)
          name == other.name && table_name == other.table_name && method.call == other.method.call
        end
      end
    end
  end
end
