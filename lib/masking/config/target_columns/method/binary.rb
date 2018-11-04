# frozen_string_literal: true

module Masking
  class Config
    class TargetColumns
      class Method
        class Binary
          def initialize(value)
            @binary = value
          end

          def call
            # TODO: should put with Encoding::ASCII_8BIT
            "_binary '#{binary}'".dup.force_encoding(Encoding::UTF_8)
          end

          private

          attr_reader :binary
        end
      end
    end
  end
end
