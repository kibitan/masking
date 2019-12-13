# frozen_string_literal: true

module Masking
  class Config
    class MaskColumns
      class Method
        class Binary
          def initialize(value)
            @binary = value
          end

          def call
            "_binary '#{binary}'".b
          end

          private

          attr_reader :binary
        end
      end
    end
  end
end
