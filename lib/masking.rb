# frozen_string_literal: true

require 'masking/version'
require 'masking/cli'
require 'masking/config'
require 'masking/sql_dump_line'

module Masking
  class << self
    def run
      Main.new.run
    end

    def config
      Masking::Config
    end
  end

  class Main
    def initialize(input: $stdin, output: $stdout)
      @input  = input
      @output = output
    end

    def run
      ## NOTE: probably here has memory consumption issue when STDIN is bigger
      input.each_line do |line|
        output.print SQLDumpLine.new(line).output
      end
    end

    private

    attr_reader :input, :output
  end
end
