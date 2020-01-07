# frozen_string_literal: true

module Masking
  class Config
    class MaskColumns
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
