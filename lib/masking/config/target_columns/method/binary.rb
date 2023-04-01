# frozen_string_literal: true
require 'masking/config/target_columns/method/methodable'

module Masking
  class Config
    class TargetColumns
      class Method
        class Binary
          include Methodable

          def call
            "_binary '#{value}'".b
          end
        end
      end
    end
  end
end
