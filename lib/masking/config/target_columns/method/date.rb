# frozen_string_literal: true
require 'masking/config/target_columns/method/methodable'
require 'date'

module Masking
  class Config
    class TargetColumns
      class Method
        class Date
          include Methodable

          def call
            "'#{date_format}'"
          end

          private

          FORMAT = '%Y-%m-%d'

          def date_format
            value.strftime(FORMAT)
          end
        end
      end
    end
  end
end
