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

  pending 'with various type of data'

  context 'error handling(unhappy path)' do
    context 'with not exists config' do
      command_subject('masking -c not_exists.yml', stdin: insert_statement_fixture)

      it 'should failed with error message', :aggregate_failures do
        expect(stdout).to be_empty
        expect(stderr).to eq "ERROR: config file (not_exists.yml) does not exist\n"
        expect(exitstatus).to eq(1)
      end
    end

    context 'with directory path (not file)' do
      command_subject('masking -c tmp/', stdin: insert_statement_fixture)

      it 'should failed with error message', :aggregate_failures do
        expect(stdout).to be_empty
        expect(stderr).to eq "ERROR: config file (tmp/) is not file\n"
        expect(exitstatus).to eq(1)
      end
    end

    context 'with invalid yaml file path' do
      command_subject("masking -c #{config_fixture_path('invalid_yaml.yml')}", stdin: insert_statement_fixture)

      it 'should failed with error message', :aggregate_failures do
        expect(stdout).to be_empty
        expect(stderr).to eq "ERROR: config file (spec/fixtures/config/invalid_yaml.yml) is not valid yaml format\n"
        expect(exitstatus).to eq(1)
      end
    end

    pending 'with invalid config structure'
    pending 'with sqldump without `--complete-insert` option'
  end
end
