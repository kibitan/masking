#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift('./lib')
require 'benchmark'
require 'masking'

Masking.configure do |config|
  config.target_columns_file_path = 'benchmark/masking.yml'
end

n = 30

fixture = File.open('benchmark/users.sql')

Benchmark.bm do |x|
  x.report do
    n.times do
      Masking::Main.new(input: fixture, output: File.open(File::NULL, 'w')).run
      fixture.rewind
    end
  end
end
