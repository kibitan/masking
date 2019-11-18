# frozen_string_literal: true

module Masking
  class DataMaskProcessor
    class Cache
      def self.fetch(key)
        @cache ||= {}
        @cache[key]
      end

      def self.store(key, value)
        @cache[key] = value
      end
    end
  end
end
