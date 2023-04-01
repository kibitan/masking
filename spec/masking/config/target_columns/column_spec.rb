# frozen_string_literal: true

require 'spec_helper'

require 'masking/config/target_columns/column'
require 'masking/config/target_columns/table'

RSpec.describe Masking::Config::TargetColumns::Column do
  let(:name)         { 'sample_column' }
  let(:table_name)   { 'sample_table' }
  let(:method_value) { 'sample_method' }

  let(:subject_object) { described_class.new(name, table_name: table_name, method_value: method_value) }

  describe '#name' do
    subject { subject_object.name }

    it { is_expected.to eq :sample_column }

    context 'column name is nil' do
      let(:name) { nil }

      it { expect { subject }.to raise_error Masking::Config::TargetColumns::Column::ColumnNameIsNil }
    end
  end

  describe '#table_name' do
    subject { subject_object.table_name }

    it { is_expected.to eq :sample_table }
  end

  describe '#==(other)' do
    subject do
      described_class.new(name, table_name: table_name, method_value: method_value) == # rubocop:disable Lint/BinaryOperatorWithIdenticalOperands
        described_class.new(name, table_name: table_name, method_value: method_value)
    end

    it { is_expected.to be true }
  end

  describe '#ignore_null?' do
    subject { subject_object.ignore_null? }

    it { is_expected.to be false }
  end

  context "when column_name is end with '?'" do
    let(:name) { 'sample_column?' }

    describe '#name' do
      subject { subject_object.name }

      it { is_expected.to eq :sample_column }
    end

    describe '#ignore_null?' do
      subject { subject_object.ignore_null? }

      it { is_expected.to be true }
    end
  end
end
