# frozen_string_literal: true

module Masking
  class Config
    class TargetColumns
      class Method
        class String
          def initialize(value)
            @value = value
            @sequence = 0
          end

          def call
            "'#{output}'".b
          end

          private

          SEQUENTIAL_NUMBER_PLACEHOLDER = '%{n}' # rubocop:disable Style/FormatStringToken
          attr_reader :value

          def output
            value.sub(SEQUENTIAL_NUMBER_PLACEHOLDER, sequence.to_s)
          end

          def sequence
            @sequence += 1
          end
        end
      end
    end
  end
end
