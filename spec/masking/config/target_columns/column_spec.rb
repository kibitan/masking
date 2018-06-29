require "masking/config/target_columns/column"
require "masking/config/target_columns/table"

RSpec.describe Masking::Config::TargetColumns::Column do
  let(:name)        { 'sample_column' }
  let(:table_name)  { 'sample_table' }
  let(:method)      { 'sample_method' }

  describe '#table_name' do
    subject { described_class.new(name, table_name: table_name, method: method).name }

    it { is_expected.to eq :sample_column }
  end

  describe '#table_name' do
    subject { described_class.new(name, table_name: table_name, method: method).table_name }

    it { is_expected.to eq :sample_table }
  end

  describe '#==(other)' do
    subject { described_class.new(name, table_name: table_name, method: method) == described_class.new(name, table_name: table_name, method: method) }

    it { is_expected.to be true }
  end

  describe '#masked_value' do
    subject { described_class.new(name, table_name: table_name, method: method).masked_value }

    it do
      expect(Masking::Config::TargetColumns::Method).to receive(:new).with(method).and_return(
        instance_double(Masking::Config::TargetColumns::Method::String, call: nil)
      )
      subject
    end
  end
end
