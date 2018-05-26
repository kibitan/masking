module Masking
  module Config
    class TargetColumns
      class Column
        attr_reader :name, :table

        def initialize(name, table:)
          @name  = name.to_sym
          @table = table.to_sym
        end

        def ==(other)
          name == other.name && table == other.table
        end
      end
    end
  end
end
