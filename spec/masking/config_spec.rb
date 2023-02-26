# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Masking::Config do
  describe 'Masking.config' do
    subject { Masking.config }

    it { is_expected.to be_instance_of described_class }
  end

  describe 'Masking.configure' do
    subject do
      Masking.configure do |config|
        config.sample_method = :sample
      end
    end

    it 'delegate method to config object' do
      expect_any_instance_of(described_class).to receive(:sample_method=).with(:sample)
      subject
    end
  end

  describe '#target_columns_file_path' do
    subject { config.target_columns_file_path }

    let(:config) { described_class.new }

    context 'setting with default' do
      it { expect(config.target_columns_file_path).to eq Pathname('masking.yml') }
    end
  end

  describe '#target_columns_file_path=' do
    subject { config.target_columns_file_path = target_columns_file_path }

    let(:config) { described_class.new }
    let(:target_columns_file_path) { config_fixture_path }

    it 'set target_columns_file_path' do
      subject
      expect(config.target_columns_file_path).to eq Pathname(config_fixture_path)
      expect(config.target_columns).to eq Masking::Config::TargetColumns.new(config_fixture_path)
    end
  end

  describe '#target_columns' do
    subject { config.target_columns }

    let(:config) { described_class.new }

    it 'return Masking::Config::TargetColumns' do
      expect(Masking::Config::TargetColumns).to receive(:new).with(Pathname('masking.yml'))
      subject
    end
  end
end
