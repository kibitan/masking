# frozen_string_literal: true

require 'spec_helper'
require 'masking/config/file_parser'

RSpec.describe Masking::Config::FileParser do
  describe '.parse' do
    subject { described_class.parse(file_path) }
    let(:file_path) { config_fixture_path }

    it {
      is_expected.to eq({
        users: {
          name: 'name',
          email: 'email',
          password_digest: 'string'
        }
      })
    }

    context 'unhappy path' do
      context 'file_path does NOT exist' do
        let(:file_path) { Pathname('unexist.txt') }

        it 'raise error' do
          expect { subject }.to raise_error Masking::Error::ConfigFileDoesNotExist
        end
      end

      context 'file_path is directory(NOT file)' do
        let(:file_path) { Pathname('tmp/') }

        it 'raise error' do
          expect { subject }.to raise_error Masking::Error::ConfigFileIsNotFile
        end
      end

      context 'file_path is NOT valid Yaml' do
        let(:file_path) { config_fixture_path('invalid_yaml.yml') }

        it 'raise error' do
          expect { subject }.to raise_error Masking::Error::ConfigFileIsNotValidYaml
        end
      end

      context 'file is NOT valid Yaml(contains null as column name)' do
        let(:file_path) { config_fixture_path('invalid_yaml_null_column.yml') }

        it 'raise error' do
          expect { subject }.to raise_error Masking::Error::ConfigFileContainsNullAsColumnName
        end
      end
    end
  end
end
