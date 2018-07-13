module Masking
  module Config
    class TargetColumns
      class Method
        class Float
          def initialize(value)
            @float = value
          end

          def call
            float.to_s
          end

          private

          attr_reader :float
        end
      end
    end
  end
end
