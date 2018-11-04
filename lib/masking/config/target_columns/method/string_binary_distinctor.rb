# frozen_string_literal: true

require 'masking/config/target_columns/method/binary'
require 'masking/config/target_columns/method/string'

module Masking
  class Config
    class TargetColumns
      class Method
        module StringBinaryDistinctor
          class << self
            def new(value)
              binary?(value) ? Binary.new(value) : String.new(value)
            end

            private

            # NOTE: this is referenced code from standard library
            #   ruby/psych: Rely on encoding tags to determine if string should be dumped as binary
            #   https://github.com/ruby/psych/commit/8949a47b8cee31e03e21608406ba116adcf74054
            #   https://github.com/ruby/psych/issues/278
            #   https://github.com/ruby/psych/blob/e01839af57df559b26f74e906062be6c692c89c8/lib/psych/visitors/yaml_tree.rb#L419-L421
            def binary?(string)
              string.encoding == Encoding::ASCII_8BIT
            end
          end
        end
      end
    end
  end
end
