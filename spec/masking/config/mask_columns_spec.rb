# frozen_string_literal: true

require 'spec_helper'

require 'masking/config/mask_columns'

RSpec.describe Masking::Config::MaskColumns do
  describe '#columns' do
    subject { Masking::Config::MaskColumns.new(file, parser: parser).columns }
    let(:file) { double('file') }
    let(:parser) { class_double(Masking::Config::FileParser, parse: data) }
    let(:data) { { users: { name: 'name', email: 'email', password_digest: 'string'} } }

    it {
      is_expected.to match [
        Masking::Config::MaskColumns::Column.new('name',            table_name: 'users', method_value: 'name'),
        Masking::Config::MaskColumns::Column.new('email',           table_name: 'users', method_value: 'email'),
        Masking::Config::MaskColumns::Column.new('password_digest', table_name: 'users', method_value: 'string')
      ]
    }
  end

  describe '#contains?' do
    context 'arguments has just table_name' do
      subject { described_class.new(file_path).contains_table?(table_name) }
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
end
