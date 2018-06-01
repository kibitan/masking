require "masking/config/target_columns/table"
require "masking/config/target_columns/column"

module Masking
  module Config
    # TODO: find better naming of TargetColumns
    class TargetColumns
      ## TODO: singletonize?
      require 'yaml'

      DEFAULT_TARGET_COLUMNS_YAML_PATH = Pathname('config/target_columns.yml').freeze
      attr_reader :file_path

      def initialize(file_path = DEFAULT_TARGET_COLUMNS_YAML_PATH)
        @file_path = file_path
      end

      def contains?(table:)
        data.has_key?(table)
      end

      private
      def data
        @data ||= YAML.load(file_path.read)
      end

      # TODO: extract to other class
      def tables
        @tables ||= [].tap do |arr|
          data.each do |table_name, columns|
            arr << Table.new(table_name, columns: columns.keys)
          end
        end
      end
    end
  end
end
