module Masking
  module Config
    class TargetColumns
      class Method
        class Null
          def initialize(*); end

          def call
            'NULL'
          end
        end
      end
    end
  end
end
