# frozen_string_literal: true

require 'spec_helper'

require 'masking/cli/error_message'

RSpec.describe Masking::Cli::ErrorMessage do
  describe '#message' do
    subject { described_class.new(error).message(**keyword_args) }

    describe 'Masking::Error::ConfigFileDoesNotExist' do
      let(:error) { Masking::Error::ConfigFileDoesNotExist }
      let(:keyword_args) { { config_file_path: 'tmp/target_columns.yml' } }

      it { is_expected.to eq 'ERROR: config file (tmp/target_columns.yml) does not exist' }
    end

    describe 'Masking::Error::ConfigFileIsNotFile' do
      let(:error) { Masking::Error::ConfigFileIsNotFile }
      let(:keyword_args) { { config_file_path: 'tmp/target_columns.yml' } }

      it { is_expected.to eq 'ERROR: config file (tmp/target_columns.yml) is not file' }
    end

    describe 'Masking::Error::ConfigFileIsNotValidYaml' do
      let(:error) { Masking::Error::ConfigFileIsNotValidYaml }
      let(:keyword_args) { { config_file_path: 'tmp/target_columns.yml' } }

      it { is_expected.to eq 'ERROR: config file (tmp/target_columns.yml) is not valid yaml format' }
    end

    describe 'Masking::Error::ConfigFileContainsNullAsColumnName' do
      let(:error) { Masking::Error::ConfigFileContainsNullAsColumnName }
      let(:keyword_args) { { config_file_path: 'tmp/target_columns.yml' } }

      it {
        expect(subject).to eq \
          'ERROR: config file (tmp/target_columns.yml) is not valid, ' \
          'column name contains `null`'
      }
    end

    describe 'Masking::Error::InsertStatementParseError' do
      let(:error) { Masking::Error::InsertStatementParseError }
      let(:keyword_args) { {} }

      it {
        expect(subject).to eq \
          'ERROR: cannot parse SQL dump file. you may forget to put `--complete-insert` option in mysqldump?'
      }
    end
  end
end
