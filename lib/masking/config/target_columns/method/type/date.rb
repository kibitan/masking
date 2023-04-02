# frozen_string_literal: true

require 'masking/config/target_columns/method/type/base'
require 'date'

module Masking
  class Config
    class TargetColumns
      class Method
        module Type
          class Date < Base
            def call(_sql_value)
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
end
