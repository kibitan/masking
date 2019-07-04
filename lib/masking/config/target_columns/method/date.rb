# frozen_string_literal: true

require 'date'

module Masking
  class Config
    class TargetColumns
      class Method
        class Date
          def initialize(value)
            @date = value.strftime(FORMAT)
          end

          def call
            "'#{date_format}'"
          end

          private

          attr_reader :date
          FORMAT = '%Y-%m-%d'

          def date_format
            date
          end
        end
      end
    end
  end
end
