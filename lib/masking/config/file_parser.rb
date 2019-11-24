# frozen_string_literal: true

require 'yaml'
require 'masking/errors'

module Masking
  class Config
    class FileParser
      attr_reader :file_path

      def initialize(file_path)
        @file_path = file_path

        raise Masking::Error::ConfigFileDoesNotExist unless file_path.exist?
        raise Masking::Error::ConfigFileIsNotFile unless file_path.file?
      end

      def parse
        data
      end

      private

      def data
        @data ||= YAML.safe_load(file_path.read, permitted_classes: [Date, Time], symbolize_names: true)
      rescue Psych::SyntaxError
        raise Masking::Error::ConfigFileIsNotValidYaml
      end
    end
  end
end
