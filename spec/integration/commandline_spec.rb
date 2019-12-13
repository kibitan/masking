# frozen_string_literal: true

require_relative 'integration_spec_helper'

RSpec.describe 'execute in command line' do
  context 'with version option' do
    command_subject('masking -v')

    it 'should put version', :aggregate_failures do
      expect(stdout).to eq(Masking::VERSION + "\n")
      expect(stderr).to be_empty
      expect(exitstatus).to eq(0)
    end
  end

  context 'with mask_columns.yml' do
    command_subject("masking -c #{config_fixture_path}", stdin: insert_statement_fixture)

    it 'should masked correctly', :aggregate_failures do
      expect(stdout).to eq(insert_statement_fixture('sample_masked.sql'))
      expect(stderr).to be_empty
      expect(exitstatus).to eq(0)
    end
  end

  context 'with various type of data' do
    context 'config file with sequential_number_replace' do
      context 'multiple insert statement lines for same table' do
        command_subject(
          "masking -c #{config_fixture_path('masking_with_sequential_number_replace.yml')}",
          stdin: sql_dump_line_fixture('multiple_lines_of_users.sql')
        )

        it 'should masked correctly', :aggregate_failures do
          expect(stdout).to eq(sql_dump_line_fixture('masked_multiple_lines_of_users.sql'))
          expect(stderr).to be_empty
          expect(exitstatus).to eq(0)
        end
      end
    end
  end

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

    context 'with invalid yaml file path' do
      command_subject(
        "masking -c #{config_fixture_path('invalid_yaml_null_column.yml')}",
        stdin: insert_statement_fixture
      )

      it 'should failed with error message', :aggregate_failures do
        expect(stdout).to be_empty
        expect(stderr).to eq \
          'ERROR: config file (spec/fixtures/config/invalid_yaml_null_column.yml) is not valid, ' \
          "column name contains `null`\n"
        expect(exitstatus).to eq(1)
      end
    end

    pending 'with invalid config structure'

    shared_examples_for 'should fail with parse error message' do
      it 'should failed with error message', :aggregate_failures do
        expect(stdout).to be_empty
        expect(stderr).to eq(
          "ERROR: cannot parse SQL dump file. you may forget to put `--complete-insert` option in mysqldump?\n"
        )
        expect(exitstatus).to eq(1)
      end
    end

    context 'with sqldump which is not specified `--complete-insert` option' do
      command_subject(
        "masking -c #{config_fixture_path}",
        stdin: insert_statement_fixture('without_complete_insert_option.sql')
      )

      it_behaves_like 'should fail with parse error message'
    end

    context 'with sqldump which contains invalid insert statement' do
      command_subject(
        "masking -c #{config_fixture_path}",
        stdin: insert_statement_fixture('invalid_insert_statement.sql')
      )

      it_behaves_like 'should fail with parse error message'
    end
  end
end
