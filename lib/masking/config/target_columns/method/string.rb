# frozen_string_literal: true

require 'masking/config/target_columns/method/methodable'

module Masking
  class Config
    class TargetColumns
      class Method
        class String
          include Methodable

          def initialize(value)
            super(value)
            @sequence = 0
          end

          def call(_sql_value)
            sequence!
            "'#{output}'".b
          end

          private

          SEQUENTIAL_NUMBER_PLACEHOLDER = '%{n}' # rubocop:disable Style/FormatStringToken

          def output
            value.sub(SEQUENTIAL_NUMBER_PLACEHOLDER, @sequence.to_s)
          end

          def sequence!
            @sequence += 1
          end
        end
      end
    end
  end
end
