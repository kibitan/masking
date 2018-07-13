# frozen_string_literal: true

Dir[Pathname(__FILE__).dirname.join('method/*.rb').to_s].each(&method(:require))
require 'forwardable'

module Masking
  module Config
    class TargetColumns
      class Method
        extend Forwardable

        def initialize(method)
          @method_type = mapping(method.class).new(method)
        end

        def_delegator :@method_type, :call

        private

        MAPPING = {
          ::String     => String,
          ::Integer    => Integer,
          ::Float      => Float,
          ::Date       => Date,
          ::Time       => Time,
          ::TrueClass  => Boolean,
          ::FalseClass => Boolean,
          ::NilClass   => Null
        }.freeze

        def mapping(klass)
          MAPPING[klass] || raise(UnknownType)
        end

        class UnknownType < RuntimeError; end
      end
    end
  end
end
