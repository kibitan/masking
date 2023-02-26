# frozen_string_literal: true

require 'spec_helper'

require 'masking/config/target_columns/column'
require 'masking/config/target_columns/table'

RSpec.describe Masking::Config::TargetColumns::Column do
  let(:name)         { 'sample_column' }
  let(:table_name)   { 'sample_table' }
  let(:method_value) { 'sample_method' }

  describe '#name' do
    subject { described_class.new(name, table_name: table_name, method_value: method_value).name }

    it { is_expected.to eq :sample_column }

    context 'column name is nil' do
      let(:name) { nil }

      it { expect { subject }.to raise_error Masking::Config::TargetColumns::Column::ColumnNameIsNil }
    end
  end

  describe '#table_name' do
    subject { described_class.new(name, table_name: table_name, method_value: method_value).table_name }

    it { is_expected.to eq :sample_table }
  end

  describe '#==(other)' do
    subject do
      described_class.new(name, table_name: table_name, method_value: method_value) == # rubocop:disable Lint/BinaryOperatorWithIdenticalOperands
        described_class.new(name, table_name: table_name, method_value: method_value)
    end

    it { is_expected.to be true }
  end
end
