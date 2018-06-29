module Masking
  module Config
    class TargetColumns
      class Method
        class String
          def initialize(value)
            @string = value
          end

          def call
            "'#{string}'"
          end

          private
          attr_reader :string
        end
      end
    end
  end
end
