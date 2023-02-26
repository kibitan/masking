# frozen_string_literal: true

require 'pathname'
require 'erb'
require 'ostruct'

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

      YAML_FILE_PATH = Pathname('lib/masking/cli/error_messages.yml')

      def error_messages
        @error_messages = YAML.safe_load(YAML_FILE_PATH.read)
      end

      def error_message(keyword_args)
        ERB.new(
          error_messages.fetch(error_class.to_s)
        ).result(
          Struct.new(keyword_args).instance_eval { binding }
        )
      end
    end
  end
end
