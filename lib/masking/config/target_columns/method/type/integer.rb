# frozen_string_literal: true

require 'masking/config/target_columns/method/Type'

module Masking
  class Config
    class TargetColumns
      class Method
        module Type
          class Integer
            include Masking::Config::TargetColumns::Method::Type

            def call(_sql_value)
              value.to_s
            end
          end
        end
      end
    end
  end
end
