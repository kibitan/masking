# frozen_string_literal: true

require 'spec_helper'
require 'masking/config/file_parser'

RSpec.describe Masking::Config::FileParser do
  describe '.parse' do
    subject { described_class.new(file_path).parse }
    let(:file_path) { config_fixture_path }

    it {
      is_expected.to eq(
        admin: {
          email: 'email+%{n}@example.com', # rubocop:disable Style/FormatStringToken
          first_name: 'good_naming',
          last_name: 'nice_name'
        },
        users: {
          name: 'name',
          email: 'email',
          password_digest: 'string',
          integer: 12_345,
          float: 123.45,
          boolean: true,
          null_column: nil,
          date: Date.new(2018, 8, 24),
          time: Time.utc(2018, 8, 24, 15, 54, 6)
        }
      )
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

      # wait for https://github.com/ruby/psych/pull/423
      pending 'file is NOT valid Yaml(contains null as column name)' do
        let(:file_path) { config_fixture_path('invalid_yaml_null_column.yml') }

        it 'raise error' do
          expect { subject }.to raise_error Masking::Error::ConfigFileContainsNullAsColumnName
        end
      end
    end
  end
end
