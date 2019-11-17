# frozen_string_literal: true

module Masking
  class DataMaskProcessor
    class Cache
      def self.fetch_or_store_if_no_cache(table_name, column_indexes_mask_methods)
        @cache ||= {}

        if @cache.key?(table_name)
          @cache[table_name]
        else
          @cache[table_name] = column_indexes_mask_methods
        end
      end

      # onlu for test
      def self.clear
        @cache = {}
      end
    end
  end
end
