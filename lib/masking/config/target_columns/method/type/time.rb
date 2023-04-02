# frozen_string_literal: true

require 'masking/config/target_columns/method/type/base'

module Masking
  class Config
    class TargetColumns
      class Method
        module Type
          class Time < Base
            def call(_sql_value)
              "'#{time_format}'"
            end

            private

            FORMAT = '%Y-%m-%d %H:%M:%S'
            def time_format
              value.strftime(FORMAT)
            end
          end
        end
      end
    end
  end
end
