# frozen_string_literal: true

# Global Errors in Masking library
module Masking
  class Error < StandardError
    class ConfigFileDoesNotExist < Error; end
    class ConfigFileIsNotFile < Error; end
    class ConfigFileIsNotValidYaml < Error; end
    class ConfigFileContainsNullAsColumnName < Error; end
    class InsertStatementParseError < Error; end
  end
end
