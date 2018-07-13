# frozen_string_literal: true

require 'masking/insert_statement/value'

RSpec.describe Masking::InsertStatement::Value do
  describe '.new' do
    subject { described_class.new(columns: columns, data: data) }
    let(:columns) { %i[id name email address] }
    let(:data) { %w[1 'John' 'john@example.com' 'berlin'] }

    it 'has reader of data' do
      expect(subject.id).to      eq '1'
      expect(subject.name).to    eq "'John'"
      expect(subject.email).to   eq "'john@example.com'"
      expect(subject.address).to eq "'berlin'"
    end
  end

  describe 'writer' do
    subject { described_class.new(columns: columns, data: data) }
    let(:columns) { %i[id name email address] }
    let(:data) { %w[1 'John' 'john@example.com' 'berlin'] }

    it 'has writer of data' do
      expect { subject.name = "'George'" }.to change { subject.name }
        .from("'John'")
        .to("'George'")
    end
  end

  describe '#phrase' do
    subject { described_class.new(columns: columns, data: data).phrase }
    let(:columns) { %i[id name email address] }
    let(:data) { %w[1 'John' 'john@example.com' 'berlin'] }

    it { is_expected.to eq %|(1,'John','john@example.com','berlin')| }
  end

  describe '#==' do
    subject { described_class.new(columns: columns, data: data) == described_class.new(columns: columns, data: data) }
    let(:columns) { %i[id name email address] }
    let(:data) { %w[1 'John' 'john@example.com' 'berlin'] }

    it { is_expected.to be true }
  end

  describe '#has_column?' do
    subject { described_class.new(columns: columns, data: []).has_column?(column_name) }
    let(:columns) { %i[id name email address] }

    context 'argument column name is in columns' do
      context 'string' do
        let(:column_name) { 'name' }

        it { is_expected.to be true }
      end

      context 'symbol' do
        let(:column_name) { :name }

        it { is_expected.to be true }
      end
    end

    context 'argument column name is NOT in columns' do
      context 'string' do
        let(:column_name) { 'hoge' }

        it { is_expected.to be false }
      end

      context 'symbol' do
        let(:column_name) { :hoge }

        it { is_expected.to be false }
      end
    end
  end
end
