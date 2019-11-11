# frozen_string_literal: true

require 'masking/config'
require 'masking/errors'
require 'masking/cli/error_message'
require 'optparse'

module Masking
  class Cli
    def initialize(argv)
      @argv = argv
    end

    def run
      option_parser.parse(argv)
      Masking.run
    rescue Masking::Error => e
      warn(Masking::Cli::ErrorMessage.new(e).message(config_file_path: Masking.config.target_columns_file_path))
      exit(false)
    end

    private

    attr_reader :argv

    def option_parser
      OptionParser.new do |parser|
        parser.banner = 'Usage: masking [options]'

        define_config_option(parser)
        define_version_option(parser)
      end
    end

    def define_config_option(parser)
      parser.on('-cFILE_PATH', '--config=FILE_PATH', 'specify config file. default: masking.yml') do |file_path|
        Masking.configure do |config|
          config.target_columns_file_path = file_path
        end
      end
    end

    def define_version_option(parser)
      parser.on('-v', '--version', 'version') do
        puts Masking::VERSION
        exit(true)
      end
    end
  end
end
