module Masking
  module Config
    class TargetColumns
      ## TODO: singletonize?
      require 'yaml'

      DEFAULT_TARGET_COLUMNS_YAML_PATH = Pathname('config/target_columns.yml').freeze
      attr_reader :file_path

      def initialize(file_path = DEFAULT_TARGET_COLUMNS_YAML_PATH)
        @file_path = file_path
      end

      def contains?(table_name:)
        data.has_key?(table_name)
      end

      private
      def data
        @data ||= YAML.load(file_path.read)
      end
    end
  end
end
