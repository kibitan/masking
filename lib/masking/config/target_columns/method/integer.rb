# frozen_string_literal: true

require 'masking/config/target_columns/method/methodable'

module Masking
  class Config
    class TargetColumns
      class Method
        class Integer
          include Methodable

          def call(_sql_value)
            value.to_s
          end
        end
      end
    end
  end
end
