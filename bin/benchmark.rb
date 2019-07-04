#!/usr/bin/env ruby
$:.unshift('./lib')
require 'benchmark'
require 'masking'

n = 10_000

Masking.configure do |config|
  config.target_columns_file_path = 'spec/fixtures/config/masking.yml'
end

fixture = File.open('spec/fixtures/insert_statement/sample.sql')

Benchmark.bm do |x|
  x.report do
    n.times do
      Masking::Main.new(input: fixture, output: File.open(File::NULL, 'w')).run
      fixture.rewind
    end
  end
end
