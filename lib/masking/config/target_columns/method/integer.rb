# frozen_string_literal: true

module Masking
  class Config
    class TargetColumns
      class Method
        class Integer
          def initialize(value)
            @value = value
          end

          def call
            value.to_s
          end

          private

          attr_reader :value
        end
      end
    end
  end
end
