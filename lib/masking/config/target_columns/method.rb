# frozen_string_literal: true

require 'pathname'
require 'forwardable'
require 'masking/config/target_columns/method/ignore_null'
require 'masking/config/target_columns/method/string_binary_distinctor'
Dir[Pathname(__FILE__).dirname.join('method/type/*.rb').to_s].sort.each(&method(:require))

module Masking
  class Config
    class TargetColumns
      class Method
        extend Forwardable

        def initialize(method, ignore_null: false)
          @method_type = mapping(method.class).new(method).tap do |obj|
            obj.singleton_class.prepend(IgnoreNull) if ignore_null
          end
        end

        def_delegator :@method_type, :call

        private

        # rubocop:disable Layout/HashAlignment
        MAPPING = {
          ::String     => StringBinaryDistinctor,
          ::Integer    => Type::Integer,
          ::Float      => Type::Float,
          ::Date       => Type::Date,
          ::Time       => Type::Time,
          ::TrueClass  => Type::Boolean,
          ::FalseClass => Type::Boolean,
          ::NilClass   => Type::Null
        }.freeze
        # rubocop:enable Layout/HashAlignment

        def mapping(klass)
          MAPPING[klass] || raise(UnknownType)
        end

        class UnknownType < RuntimeError; end
      end
    end
  end
end
