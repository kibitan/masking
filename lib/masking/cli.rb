require "thor"

module Masking
  class Cli < ::Thor
    default_command :mask

    desc "mask", 'mask database value'
    def mask
      Masking.run
    end
  end
end
