# frozen_string_literal: true

require 'pathname'
require 'masking/config/target_columns'

module Masking
  class << self
    def config(config_class: Config.new)
      @config ||= config_class
    end

    def configure
      yield config
    end
  end

  class Config
    DEFAULT_FILE_PATH = Pathname('masking.yml')
    attr_reader :file_path

    def initialize(mask_column_class: TargetColumns)
      @file_path = DEFAULT_FILE_PATH
      @mask_column_class = mask_column_class
    end

    def file_path=(val)
      @file_path = Pathname(val)
      @mask_columns = mask_column_class.new(file_path)
    end

    def mask_columns
      @mask_columns ||= mask_column_class.new(file_path)
    end

    private

    attr_reader :mask_column_class
  end
end
