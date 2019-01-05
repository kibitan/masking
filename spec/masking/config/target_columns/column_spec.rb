# frozen_string_literal: true

require 'spec_helper'

require 'masking/config/target_columns/column'
require 'masking/config/target_columns/table'

RSpec.describe Masking::Config::TargetColumns::Column do
  let(:name)         { 'sample_column' }
  let(:table_name)   { 'sample_table' }
  let(:method_value) { 'sample_method' }

  describe '#table_name' do
    subject { described_class.new(name, table_name: table_name, method_value: method_value).name }

    it { is_expected.to eq :sample_column }
  end

  describe '#table_name' do
    subject { described_class.new(name, table_name: table_name, method_value: method_value).table_name }

    it { is_expected.to eq :sample_table }
  end

  describe '#==(other)' do
    subject do
      described_class.new(name, table_name: table_name, method_value: method_value) == # rubocop:disable Lint/UselessComparison,Metrics/LineLength
        described_class.new(name, table_name: table_name, method_value: method_value)
    end

    it { is_expected.to be true }
  end

  describe '#masked_value' do
    subject { described_class.new(name, table_name: table_name, method_value: method_value).masked_value }

    it do
      expect(Masking::Config::TargetColumns::Method).to receive(:new).with(method_value).and_return(
        instance_double(Masking::Config::TargetColumns::Method::String, call: nil)
      )
      subject
    end
  end
end
