# frozen_string_literal: true

require 'masking/cli'
require 'masking/config'
require 'masking/sql_dump_line'

module Masking
  class << self
    def run
      Main.new.run
    end
  end

  class Main
    def initialize(input: $stdin, output: $stdout, line_processor: SQLDumpLine)
      @input  = input.set_encoding(Encoding::ASCII_8BIT, Encoding::ASCII_8BIT)
      @output = output.set_encoding(Encoding::ASCII_8BIT, Encoding::ASCII_8BIT)
      @line_processor = line_processor
    end

    def run
      input.each_line do |line|
        output.print line_processor.new(line).output
      end
    end

    private

    attr_reader :input, :output, :line_processor
  end
end
