# frozen_string_literal: true

require 'delegate'

module Masking
  class InsertStatement
    class Value < ::SimpleDelegator
      def initialize(columns:, data:)
        @columns = columns
        @data    = Struct.new(*columns).new(*data)
        # NOTE: is it better to get rid of SimpleDelegator, store data in instance variable and define accesor for it?
        super(@data)
      end

      def phrase
        '(' + to_a.join(?,) + ')'
      end

      # override for make comparable
      # NOTE: original #== method comapares struct subclass
      def ==(other)
        to_h == other.to_h
      end

      def column?(column_name)
        @columns.include?(column_name.to_sym)
      end
    end
  end
end
