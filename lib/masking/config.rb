# frozen_string_literal: true

require 'singleton'
require 'masking/config/target_columns'

module Masking
  class Config
    # TODO: get rid of Singleton
    include Singleton

    DEFAULT_TARGET_COLUMNS_YAML_PATH = Pathname('target_columns.yml')

    class << self
      def target_columns_file_path
        instance.target_columns_file_path
      end

      def target_columns_file_path=(val)
        instance.target_columns_file_path = val
      end

      def target_columns
        TargetColumns.new(target_columns_file_path)
      end
    end

    def target_columns_file_path
      @target_columns_file_path || DEFAULT_TARGET_COLUMNS_YAML_PATH
    end

    def target_columns_file_path=(val)
      @target_columns_file_path = Pathname(val)
    end
  end
end
