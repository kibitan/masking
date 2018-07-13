require "date"

module Masking
  module Config
    class TargetColumns
      class Method
        class Date
          def initialize(value)
            @date = value
          end

          def call
            "'#{date_format}'"
          end

          private

          attr_reader :date

          FORMAT = "%Y-%m-%d".freeze
          def date_format
            date.strftime(FORMAT)
          end
        end
      end
    end
  end
end
