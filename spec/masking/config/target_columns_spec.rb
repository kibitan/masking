# frozen_string_literal: true

require 'masking/config/target_columns'

RSpec.describe Masking::Config::TargetColumns do
  describe '#initialize' do
    context 'without argument' do
      subject { described_class.new }

      it 'contains default file_path' do
        expect(subject.file_path).to eq Pathname('target_columns.yml')
      end
    end

    context 'with argument(file_path)' do
      subject { described_class.new(file_path) }
      let(:file_path) { Pathname('hoge') }

      context 'file_path is valid' do
        it 'contains file_path' do
          expect(subject.file_path).to eq Pathname('hoge')
        end
      end

      pending 'file_path is NOT exists'
      pending 'file_path is NOT file'
      pending 'file_path is NOT valid Yaml'
    end
  end

  describe '#contains?' do
    context 'arguments has just table_name' do
      subject { described_class.new(file_path).contains?(table_name: table_name) }
      let(:file_path) { config_fixture_path }

      context 'table_name is included in config yaml' do
        let(:table_name) { 'users' }

        it { is_expected.to eq true }
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

    it :aggregate_failures do
      is_expected.to match [
        instance_of(Masking::Config::TargetColumns::Table),
        instance_of(Masking::Config::TargetColumns::Table)
      ]
      expect(subject[0].name).to eq :users
      expect(subject[1].name).to eq :admin
    end
  end
end
