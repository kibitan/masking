Dir[Pathname(__FILE__).dirname.join("method/*.rb").to_s].each(&method(:require))
require 'forwardable'

module Masking
  module Config
    class TargetColumns
      class Method
        extend Forwardable

        def initialize(method)
          @method_type = MAPPING[method.class].new(method)
        end

        def_delegator :@method_type, :call

        private

        MAPPING = {
          ::String   => String,
          ::Integer  => Integer,
          ::Float    => Float,
          ::Date     => Date,
          ::Time     => Time,
          ::NilClass => Null
        }.freeze
      end
    end
  end
end
