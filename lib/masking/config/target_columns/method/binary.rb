# frozen_string_literal: true

module Masking
  class Config
    class TargetColumns
      class Method
        class Binary
          def initialize(value)
            @value = value
          end

          def call
            "_binary '#{value}'".b
          end

          private

          attr_reader :value
        end
      end
    end
  end
end
