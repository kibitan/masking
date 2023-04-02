# frozen_string_literal: true

module Masking
  class Config
    class TargetColumns
      class Method
        module Type
          module Extension
            module IgnoreNull
              def call(sql_value)
                if sql_value == 'NULL'
                  sequence! if respond_to?(:sequence!, true)
                  return 'NULL'
                end

                super
              end
            end
          end
        end
      end
    end
  end
end
