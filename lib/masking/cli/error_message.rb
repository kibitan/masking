# frozen_string_literal: true

require 'erb'
require 'ostruct'
require 'masking/errors'

module Masking
  class Cli
    class ErrorMessage
      def initialize(error_class)
        @error_class = error_class
      end

      def message(**keyword_args)
        error_message(keyword_args)
      end

      private

      attr_reader :error_class

      def error_message(keyword_args)
        ERB.new(
          ERROR_MESSAGES.fetch(error_class.to_s)
        ).result(
          OpenStruct.new(keyword_args).instance_eval { binding } # rubocop:disable Style/OpenStructUse
        )
      end

      ERROR_MESSAGES = {
        'Masking::Error::ConfigFileDoesNotExist' =>
          'ERROR: config file (<%= config_file_path %>) does not exist',
        'Masking::Error::ConfigFileIsNotFile' =>
          'ERROR: config file (<%= config_file_path %>) is not file',
        'Masking::Error::ConfigFileIsNotValidYaml' =>
          'ERROR: config file (<%= config_file_path %>) is not valid yaml format',
        'Masking::Error::ConfigFileContainsNullAsColumnName' =>
          'ERROR: config file (<%= config_file_path %>) is not valid, column name contains `null`',
        'Masking::Error::InsertStatementParseError' =>
          'ERROR: cannot parse SQL dump file. you may forget to put `--complete-insert` option in mysqldump?'
      }.freeze
    end
  end
end
