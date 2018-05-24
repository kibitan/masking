require "masking/data_mask_processor"

RSpec.describe Masking::DataMaskProcessor do
  describe ".process" do
    subject { described_class.process(sql_insert_statement_line, config_fixture_path('target_columns.yml')) }
    let(:sql_insert_statement_line) { sql_insert_statement_fixture }
    let(:target_columns) { Masking::Config::TargetColumns.new(config_fixture_path('target_columns.yml')) }

    pending 'not implemented yet'
  end

  describe '#target_table?' do
    subject { described_class.new(sql_insert_statement_line, target_columns: target_columns).send(:target_table?) }
    let(:sql_insert_statement_line) { sql_insert_statement_fixture }

    context 'table is defined in target_columns' do
      let(:target_columns) { Masking::Config::TargetColumns.new(config_fixture_path('target_columns.yml')) }
      it { is_expected.to be true }
    end

    context 'table is NOT defined in target_columns' do
      let(:target_columns) { Masking::Config::TargetColumns.new(config_fixture_path('address_target_columns.yml')) }
      it { is_expected.to be false }
    end
  end
end
