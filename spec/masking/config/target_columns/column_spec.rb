require "masking/config/target_columns/column"
require "masking/config/target_columns/table"

RSpec.describe Masking::Config::TargetColumns::Column do
  let(:name)   { 'sample_column' }
  let(:method) { 'sample_method' }
  let(:table)  { spy(Masking::Config::TargetColumns::Table) }

  describe '#name' do
    subject { described_class.new(name, table: table, method: method).name }

    it { is_expected.to eq :sample_column }
  end

  describe '#table' do
    subject { described_class.new(name, table: table, method: method).table }

    it { is_expected.to eq table }
  end

  # TODO: this is temporary implementation, this should be different/flexible class
  describe '#method' do
    subject { described_class.new(name, table: table, method: method).method }

    it { expect(subject.call).to eq 'sample_method' }
  end

  describe '#==(other)' do
    subject { described_class.new(name, table: table, method: method) == described_class.new(name, table: table, method: method) }

    it { is_expected.to be true }
  end
end
