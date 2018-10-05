# frozen_string_literal: true

module Masking
  class Error < StandardError
    class ConfigFileDoesNotExist < Error; end
  end
end
