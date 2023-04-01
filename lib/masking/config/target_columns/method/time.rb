# frozen_string_literal: true
require 'masking/config/target_columns/method/methodable'

module Masking
  class Config
    class TargetColumns
      class Method
        class Time
          include Methodable

          def call
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
