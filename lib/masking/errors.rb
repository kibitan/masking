# frozen_string_literal: true

module Masking
  class Error < StandardError
    class ConfigFileDoesNotExist < Error; end
    class ConfigFileIsNotFile < Error; end
    class ConfigFileIsNotValidYaml < Error; end
    class InsertStatementParseError < Error; end
  end
end
