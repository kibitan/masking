module Masking
  require 'thor'

  class Cli < ::Thor
    default_command :execute

    desc "TODO:", 'TODO:'
    def execute
      Masking.run
    end
  end
end
