module Masking
  module Config
    class TargetColumns
      class Method
        class Time
          def initialize(value)
            @time = value
          end

          def call
            time.strftime(FORMAT)
          end

          private
          attr_reader :time
          FORMAT = "%Y-%m-%d %H:%M:%S".freeze
        end
      end
    end
  end
end
