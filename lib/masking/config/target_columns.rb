module Masking
  module Config
    class TargetColumns
      require 'yaml'

      DEFAULT_TARGET_COLUMNS_YAML_PATH = Pathname('config/target_columns.yml').freeze
      attr_reader :file_path

      def initialize(file_path = DEFAULT_TARGET_COLUMNS_YAML_PATH)
        @file_path = file_path
        @data = YAML.load(file_path.read)
      end

      def contains?(table_name:)
        data.has_key?(table_name)
      end

      private
      attr_reader :data
    end
  end
end
