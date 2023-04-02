# frozen_string_literal: true

require 'masking/config/target_columns/method/type/base'

module Masking
  class Config
    class TargetColumns
      class Method
        module Type
          class Binary < Base
            def call(_sql_value)
              "_binary '#{value}'".b
            end
          end
        end
      end
    end
  end
end
