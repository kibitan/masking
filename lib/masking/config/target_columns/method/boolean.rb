# frozen_string_literal: true

module Masking
  class Config
    class TargetColumns
      class Method
        class Boolean
          def initialize(value)
            @boolean = value
          end

          def call
            boolean_format.to_s
          end

          private

          attr_reader :boolean

          # NOTE: 11.1.1 Numeric Type Overview, chapter BOOL, BOOLEAN
          #       https://dev.mysql.com/doc/refman/8.0/en/numeric-type-overview.html
          def boolean_format
            boolean ? 1 : 0
          end
        end
      end
    end
  end
end
