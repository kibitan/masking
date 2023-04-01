# frozen_string_literal: true

require 'date'

module Masking
  class Config
    class TargetColumns
      class Method
        class Date
          def initialize(value)
            @value = value
          end

          def call
            "'#{date_format}'"
          end

          private

          attr_reader :value

          FORMAT = '%Y-%m-%d'

          def date_format
            value.strftime(FORMAT)
          end
        end
      end
    end
  end
end
