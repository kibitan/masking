require "masking/version"
require "masking/cli"

module Masking
  class << self
    def run
      Main.new.run
    end
  end

  class Main
    def initialize
    end

    def run
      ## NOTE: probably here has memory consumption issue when STDIN is bigger
      STDIN.each_line {|line|
        STDOUT.print line
      }
    end
  end
end
