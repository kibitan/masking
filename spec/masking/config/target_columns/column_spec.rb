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

  describe '#method' do
    subject { described_class.new(name, table_name: table_name, method: method).method }

    context 'when string' do
      let(:method) { 'sample string' }

      it { expect(subject.call).to eq "'sample string'" }
    end

    context 'when integer' do
      let(:method) { 123 }

      it { expect(subject.call).to eq '123' }
    end

    context 'when float' do
      let(:method) { 123.456 }

      it { expect(subject.call).to eq '123.456' }
    end

    # TODO: check all date/time format
    context 'when datetime' do
      let(:method) { '2018-03-14 15:31:02' }

      it { expect(subject.call).to eq "'2018-03-14 15:31:02'" }
    end

    context 'when nil' do
      let(:method) { nil }

      it { expect(subject.call).to eq 'NULL' }
    end
  end
end
