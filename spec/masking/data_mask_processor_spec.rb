require "masking/data_mask_processor"

RSpec.describe Masking::DataMaskProcessor do
  describe ".process" do
    subject { described_class.process(sql_insert_statement_line, target_columns: target_columns) }
    let(:sql_insert_statement_line) { sql_insert_statement_fixture }
    let(:target_columns) do
      instance_double(Masking::Config::TargetColumns).tap do |config|
        allow(config).to receive(:contains?).with(table: 'users').and_return(target_columns_stubbed_return)
      end
    end

    context 'when input SQLInsertStatement Line is NOT target_table' do
      let(:target_columns_stubbed_return) { false }

      it { is_expected.to eq(sql_insert_statement_line) }
    end

    context 'when input SQLInsertStatement Line is target_table' do
      let(:target_columns_stubbed_return) { true }

      context 'when input SQLInsertStatement Line has target_column' do
        pending 'not implemented yet'
      end
    end
  end

  describe '#target_table?' do
    subject { described_class.new(sql_insert_statement_line, target_columns: target_columns).send(:target_table?) }
    let(:sql_insert_statement_line) { sql_insert_statement_fixture }
    let(:target_columns) do
      instance_double(Masking::Config::TargetColumns).tap do |config|
        allow(config).to receive(:contains?).with(table: 'users').and_return(target_columns_stubbed_return)
      end
    end

    context 'table is defined in target_columns' do
      let(:target_columns_stubbed_return) { true }

      it { is_expected.to be true }
    end

    context 'table is NOT defined in target_columns' do
      let(:target_columns_stubbed_return) { false }

      it { is_expected.to be false }
    end
  end
end
