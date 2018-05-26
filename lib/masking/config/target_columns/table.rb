module Masking
  module Config
    class TargetColumns
      class Table
        attr_reader :name

        def initialize(name)
          @name = name.to_sym
        end
      end
    end
  end
end
