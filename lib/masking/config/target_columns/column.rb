module Masking
  module Config
    class TargetColumns
      class Column
        attr_reader :name

        def initialize(name)
          @name = name.to_sym
        end
      end
    end
  end
end
