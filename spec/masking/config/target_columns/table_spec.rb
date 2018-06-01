require "masking/config/target_columns/table"

RSpec.describe Masking::Config::TargetColumns::Table do
  let(:name) { 'sample_table' }
  let(:columns) do
    {
      column_a: :method_a,
      column_b: :method_b,
      column_c: :method_c
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
        Masking::Config::TargetColumns::Column.new('column_a', table: subject, method: 'method_a'),
        Masking::Config::TargetColumns::Column.new('column_b', table: subject, method: 'method_b'),
        Masking::Config::TargetColumns::Column.new('column_c', table: subject, method: 'method_c')
      ]
    end
  end
end
