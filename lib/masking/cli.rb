# frozen_string_literal: true

require 'masking/config'
require 'masking/errors'
require 'optparse'

module Masking
  class Cli
    def initialize(argv)
      @argv = argv
    end

    def run
      option_parser.parse(argv)
      Masking.run
    rescue Masking::Error::ConfigFileDoesNotExist
      warn "ERROR: config file (#{Masking.config.target_columns_file_path}) does not exist"
      exit(false)
    rescue Masking::Error::ConfigFileIsNotFile
      warn "ERROR: config file (#{Masking.config.target_columns_file_path}) is not file"
      exit(false)
    end

    private

    attr_reader :argv

    def option_parser
      OptionParser.new do |parser|
        parser.banner = 'Usage: masking [options]'

        define_config_option(parser)
      end
    end

    def define_config_option(parser)
      parser.on('-cFILE_PATH', '--config=FILE_PATH', 'specify config file. default: target_columns.yml') do |file_path|
        Masking.configure do |config|
          config.target_columns_file_path = file_path
        end
      end
    end
  end
end
