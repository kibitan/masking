module Masking
  module Config
    class TargetColumns
      class Method
        class Integer
          def initialize(value)
            @integer = value
          end

          def call
            integer.to_s
          end

          private
          attr_reader :integer
        end
      end
    end
  end
end
