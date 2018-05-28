require "masking/config/target_columns/column"
require "masking/config/target_columns/table"

RSpec.describe Masking::Config::TargetColumns::Column do
  let(:name)  { 'sample_column' }
  let(:table) { spy(Masking::Config::TargetColumns::Table) }

  describe '#name' do
    subject { described_class.new(name, table: table).name }

    it { is_expected.to eq :sample_column }
  end

  describe '#table' do
    subject { described_class.new(name, table: table).table }

    it { is_expected.to eq table }
  end

  describe '#==(other)' do
    subject { described_class.new(name, table: table) == described_class.new(name, table: table) }

    it { is_expected.to be true }
  end
end
