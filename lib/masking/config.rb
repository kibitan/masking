# frozen_string_literal: true

require 'pathname'
require 'masking/config/mask_columns'

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

    def initialize(mask_columns_class: MaskColumns)
      @file_path = DEFAULT_FILE_PATH
      @mask_columns_class = mask_columns_class
    end

    def file_path=(val)
      @file_path = Pathname(val)
      @mask_columns = mask_columns_class.from_file(file_path)
    end

    def mask_columns
      @mask_columns ||= mask_columns_class.from_file(file_path)
    end

    private

    attr_reader :mask_columns_class
  end
end
