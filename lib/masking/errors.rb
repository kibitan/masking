# frozen_string_literal: true

module Masking
  class Error < StandardError
    class ConfigFileDoesNotExist < Error; end
    class ConfigFileIsNotFile < Error; end
  end
end
