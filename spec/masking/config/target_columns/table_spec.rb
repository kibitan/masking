# frozen_string_literal: true

require 'spec_helper'

require 'masking/config/target_columns/table'

RSpec.describe Masking::Config::TargetColumns::Table do
  let(:name) { 'sample_table' }
  let(:columns) do
    {
      column_a: 'string',
      column_b: 123,
      column_c: nil
    }
  end

  describe '#name' do
    subject { described_class.new(name, columns: columns).name }

    it { is_expected.to eq :sample_table }
  end

  describe '#columns' do
    subject { described_class.new(name, columns: columns) }

    it do
      expect(subject.columns).to match_array [
        Masking::Config::TargetColumns::Column.new('column_a', table_name: name, method_value: 'string'),
        Masking::Config::TargetColumns::Column.new('column_b', table_name: name, method_value: 123),
        Masking::Config::TargetColumns::Column.new('column_c', table_name: name, method_value: nil)
      ]
    end
  end

  describe '#==(other)' do
    subject { described_class.new(name, columns: columns) == described_class.new(name, columns: columns) }

    it { is_expected.to be true }
  end
end
