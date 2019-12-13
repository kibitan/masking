# frozen_string_literal: true

module Masking
  class Config
    class MaskColumns
      class Method
        class Float
          def initialize(value)
            @float = value.to_s
          end

          def call
            float
          end

          private

          attr_reader :float
        end
      end
    end
  end
end
