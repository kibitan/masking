# frozen_string_literal: true

require 'pathname'
require 'masking/config/target_columns'

module Masking
  class << self
    def config
      @config ||= Config.new
    end

    def configure
      yield config
    end
  end

  class Config
    DEFAULT_TARGET_COLUMNS_YAML_PATH = Pathname('masking.yml')
    attr_reader :target_columns_file_path

    def initialize
      @target_columns_file_path = DEFAULT_TARGET_COLUMNS_YAML_PATH
    end

    def target_columns_file_path=(val)
      @target_columns_file_path = Pathname(val)
      @target_columns = TargetColumns.new(target_columns_file_path)
    end

    def target_columns
      @target_columns ||= TargetColumns.new(target_columns_file_path)
    end
  end
end
