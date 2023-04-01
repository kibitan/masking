# frozen_string_literal: true

module Masking
  class Config
    class TargetColumns
      class Method
        module Type
          class Null
            def initialize(*); end

            def call(_sql_value)
              'NULL'
            end
          end
        end
      end
    end
  end
end
