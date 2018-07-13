# frozen_string_literal: true

module Masking
  module Config
    class TargetColumns
      class Method
        class String
          def initialize(value)
            @string   = value
            @sequence = 0
          end

          def call
            "'#{output}'"
          end

          private

          attr_reader :string
          SEQUENTIAL_NUMBER_PLACEHOLDER = /%{n}/

          def output
            string.sub(SEQUENTIAL_NUMBER_PLACEHOLDER, sequence.to_s)
          end

          def sequence
            @sequence += 1
          end
        end
      end
    end
  end
end
