# frozen_string_literal: true

module Masking
  class Config
    class TargetColumns
      class Method
        module IgnoreNull
          def call(sql_value)
            sequence() if respond_to?(:sequence)
            return sql_value if sql_value == 'NULL'

            super
          end
        end
      end
    end
  end
end
