# frozen_string_literal: true

require 'yaml'
require 'masking/config/target_columns/table'
require 'masking/config/target_columns/column'

module Masking
  class Config
    # TODO: find better naming of TargetColumns
    class TargetColumns
      class FileDoesNotExist < StandardError; end

      attr_reader :file_path

      def initialize(file_path)
        @file_path = file_path

        raise FileDoesNotExist unless file_path.exist?
      end

      def contains?(table_name:)
        data.key?(table_name)
      end

      # TODO: refactoring
      def columns(table_name:)
        tables.find { |table| table.name == table_name.to_sym }&.columns
      end

      private

      def data
        @data ||= YAML.safe_load(file_path.read, [Date, Time])
      end

      # TODO: extract to other class
      def tables
        @tables ||= [].tap do |arr|
          data.each do |table_name, columns|
            arr << Table.new(table_name, columns: columns)
          end
        end
      end
    end
  end
end
