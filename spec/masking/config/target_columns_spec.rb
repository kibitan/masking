# frozen_string_literal: true

require 'spec_helper'

require 'masking/config/target_columns'

RSpec.describe Masking::Config::TargetColumns do
  describe '#initialize' do
    subject { described_class.new(file_path) }

    context 'file_path is valid' do
      let(:file_path) { config_fixture_path }

      it 'contains file_path' do
        expect(subject.file_path).to eq config_fixture_path
      end
    end

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
  end

  describe '#contains?' do
    context 'arguments has just table_name' do
      subject { described_class.new(file_path).contains?(table_name: table_name) }
      let(:file_path) { config_fixture_path }

      context 'table_name is included in config yaml' do
        let(:table_name) { 'users' }

        it { is_expected.to eq true }

        context 'file_path is NOT valid Yaml' do
          let(:file_path) { config_fixture_path('invalid_yaml.yml') }

          it 'raise error' do
            expect { subject }.to raise_error Masking::Error::ConfigFileIsNotValidYaml
          end
        end
      end

      context 'table_name is NOT included in config yaml' do
        let(:table_name) { 'hogehoge' }

        it { is_expected.to eq false }
      end
    end
  end

  describe '#columns' do
    subject { described_class.new(file_path).columns(table_name: table_name) }
    let(:file_path) { config_fixture_path }

    context 'table_name is included in config yaml' do
      let(:table_name) { 'users' }

      it do
        is_expected.to match [
          Masking::Config::TargetColumns::Column.new('name',            table_name: 'users', method_value: 'name'),
          Masking::Config::TargetColumns::Column.new('email',           table_name: 'users', method_value: 'email'),
          Masking::Config::TargetColumns::Column.new('password_digest', table_name: 'users', method_value: 'string')
        ]
      end
    end

    context 'table_name is NOT included in config yaml' do
      let(:table_name) { 'dummy_users' }

      it { is_expected.to eq nil }
    end
  end

  describe '#tables' do
    subject { described_class.new(file_path).send(:tables) }
    let(:file_path) { config_fixture_path }

    specify do
      is_expected.to match(
        admin: instance_of(Masking::Config::TargetColumns::Table),
        users: instance_of(Masking::Config::TargetColumns::Table)
      )
    end
  end
end
