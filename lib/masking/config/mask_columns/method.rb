# frozen_string_literal: true

require 'pathname'
require 'forwardable'
Dir[Pathname(__FILE__).dirname.join('method/*.rb').to_s].each(&method(:require))

module Masking
  class Config
    class MaskColumns
      class Method
        extend Forwardable

        def initialize(method)
          @method_type = mapping(method.class).new(method)
        end

        def_delegator :@method_type, :call

        private

        # rubocop:disable Layout/AlignHash
        MAPPING = {
          ::String     => StringBinaryDistinctor,
          ::Integer    => Integer,
          ::Float      => Float,
          ::Date       => Date,
          ::Time       => Time,
          ::TrueClass  => Boolean,
          ::FalseClass => Boolean,
          ::NilClass   => Null
        }.freeze
        # rubocop:enable Layout/AlignHash

        def mapping(klass)
          MAPPING[klass] || raise(UnknownType)
        end

        class UnknownType < RuntimeError; end
      end
    end
  end
end
