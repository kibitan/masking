# frozen_string_literal: true

module Masking
  class Config
    class TargetColumns
      class Method
        class String
          def initialize(value)
            @string   = value.split("%{n}")
            @sequence = 0
          end

          def call
            "'" + output + "'"
          end

          private

          attr_reader :string

          def output
            string.join(sequence.to_s)
          end

          def sequence
            @sequence += 1
          end
        end
      end
    end
  end
end
