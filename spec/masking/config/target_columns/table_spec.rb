require "masking/config/target_columns/table"

RSpec.describe Masking::Config::TargetColumns::Table do
  describe '#name' do
    subject { described_class.new(name).name }
    let(:name) { 'sample_table' }

    it { is_expected.to eq :sample_table }
  end

  describe '#columns' do
    subject { described_class.new(:table_name, columns: columns).columns }
    let(:columns) { %w(column_a column_b column_c) }

    it do
      is_expected.to match_array [
         Masking::Config::TargetColumns::Column.new('column_a'),
         Masking::Config::TargetColumns::Column.new('column_b'),
         Masking::Config::TargetColumns::Column.new('column_c')
      ]
    end
  end
end
