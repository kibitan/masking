# frozen_string_literal: true

require 'masking/config/target_columns/method/type/base'

module Masking
  class Config
    class TargetColumns
      class Method
        module Type
          class Boolean < Base
            def call(_sql_value)
              boolean_format.to_s
            end

            private

            # NOTE: 11.1.1 Numeric Type Overview, chapter BOOL, BOOLEAN
            #       https://dev.mysql.com/doc/refman/8.0/en/numeric-type-overview.html
            def boolean_format
              value ? 1 : 0
            end
          end
        end
      end
    end
  end
end
