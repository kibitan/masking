# frozen_string_literal: true

module Masking
  class Config
    class TargetColumns
      class Method
        class Time
          def initialize(value)
            @value = value
          end

          def call
            "'#{time_format}'"
          end

          private

          attr_reader :value

          FORMAT = '%Y-%m-%d %H:%M:%S'

          def time_format
            value.strftime(FORMAT)
          end
        end
      end
    end
  end
end
