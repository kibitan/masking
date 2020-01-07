# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Masking::Config do
  describe 'Masking.configure' do
    before { Masking.instance_variable_set(:@config, nil) } # clear current config
    before { Masking.config(config_class: config_class) }
    let(:config_class) { double('config_class').tap { |double| allow(double).to receive(:sample_method=) } }

    subject {
      Masking.configure do |config|
        config.sample_method = :sample_value
      end
    }

    it 'delegate method to config object' do
      expect(config_class).to receive(:sample_method=).with(:sample_value)
      subject
    end
  end

  describe '#file_path' do
    subject { Masking::Config.new.file_path }

    context 'setting with default' do
      it { is_expected.to eq Pathname('masking.yml') }
    end
  end

  describe '#file_path=' do
    let(:config) { Masking::Config.new(mask_columns_class: class_double('Test', from_file: :sample_mask_columns)) }
    subject { config.file_path = 'test.yml' }
    before { subject }

    it { expect(config.file_path).to eq Pathname('test.yml') }
    it { expect(config.mask_columns).to eq :sample_mask_columns }
  end

  describe '#mask_columns' do
    subject { Masking::Config.new(mask_columns_class: mask_columns_class).mask_columns }

    let(:mask_columns_class) {
      class_double('Test').tap do |double|
        expect(double).to receive(:from_file).with(Pathname('masking.yml')).and_return(:mask_column_called)
      end
    }

    it { is_expected.to eq :mask_column_called }
  end
end
