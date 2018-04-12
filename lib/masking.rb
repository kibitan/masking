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
      puts 'hello'
    end
  end
end
