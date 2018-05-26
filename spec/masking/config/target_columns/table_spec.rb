require "masking/config/target_columns/table"

RSpec.describe Masking::Config::TargetColumns::Table do
  let(:name) { 'sample_table' }
  let(:columns) { %w(column_a column_b column_c) }

  describe '#name' do
    subject { described_class.new(name, columns: columns).name }

    it { is_expected.to eq :sample_table }
  end

  describe '#columns' do
    subject { described_class.new(name, columns: columns).columns }

    it do
      is_expected.to match_array [
        Masking::Config::TargetColumns::Column.new('column_a', table: 'sample_table'),
        Masking::Config::TargetColumns::Column.new('column_b', table: 'sample_table'),
        Masking::Config::TargetColumns::Column.new('column_c', table: 'sample_table')
      ]
    end
  end
end
