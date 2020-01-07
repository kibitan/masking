# frozen_string_literal: true

module Masking
  class Config
    class MaskColumns
      class Method
        class Integer
          def initialize(value)
            @integer = value.to_s
          end

          def call
            integer
          end

          private

          attr_reader :integer
        end
      end
    end
  end
end
