# frozen_string_literal: true

module Masking
  class DataMaskProcessor
    class Cache
      def self.fetch_or_store_if_no_cache(table:, proc:)
        @cache ||= {}

        if @cache.key?(table)
          @cache[table]
        else
          @cache[table] = proc.call
        end
      end

      # onlu for test
      def self.clear
        @cache = {}
      end
    end
  end
end
