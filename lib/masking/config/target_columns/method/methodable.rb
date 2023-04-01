# frozen_string_literal: true

module Masking
  class Config
    class TargetColumns
      class Method
        module Methodable
          def initialize(value)
            @value = value
          end

          def call(_sql_value)
            raise NotImplementedError
          end

          private

          attr_reader :value
        end
      end
    end
  end
end
