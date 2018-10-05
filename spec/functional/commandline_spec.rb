# frozen_string_literal: true

require_relative 'functional_spec_helper'

RSpec.describe 'execute in command line' do
  context 'with target_columns.yml' do
    command_subject("masking -c #{config_fixture_path}", stdin: insert_statement_fixture)

    it 'should masked correctly', :aggregate_failures do
      expect(stdout).to eq(insert_statement_fixture('sample_masked.sql'))
      expect(stderr).to be_empty
      expect(exitstatus).to eq(0)
    end
  end
end
