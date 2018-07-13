module Masking
  module Config
    class TargetColumns
      class Method
        class Time
          def initialize(value)
            @time = value
          end

          def call
            "'#{time_format}'"
          end

          private

          attr_reader :time

          FORMAT = "%Y-%m-%d %H:%M:%S".freeze
          def time_format
            time.strftime(FORMAT)
          end
        end
      end
    end
  end
end
