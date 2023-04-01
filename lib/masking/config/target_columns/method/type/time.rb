# frozen_string_literal: true

require 'masking/config/target_columns/method/Type'

module Masking
  class Config
    class TargetColumns
      class Method
        module Type
          class Time
            include Masking::Config::TargetColumns::Method::Type

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
