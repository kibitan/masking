# frozen_string_literal: true

require 'yaml'
require 'masking/config/file_parser'
require 'masking/config/mask_columns/column'

module Masking
  class Config
    class MaskColumns
      def initialize(file, parser: FileParser, column_class: Column)
        parser.parse(file).map do |table_name, columns|
          columns.map do |column_name, method_value|
            column_class.new(column_name, table_name: table_name, method_value: method_value)
          end
        end
      end

      def contains_table?(*)
        true
      end
    end
  end
end
