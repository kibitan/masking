# frozen_string_literal: true

module Masking
  class Config
    class MaskColumns
      class Method
        class Time
          def initialize(value)
            @time = value.strftime(FORMAT)
          end

          def call
            "'#{time_format}'"
          end

          private

          attr_reader :time
          FORMAT = '%Y-%m-%d %H:%M:%S'

          def time_format
            time
          end
        end
      end
    end
  end
end
