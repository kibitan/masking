# frozen_string_literal: true

require 'spec_helper'

require 'masking/data_mask_processor'

RSpec.describe Masking::DataMaskProcessor do
  describe '#process' do
    subject { described_class.new(insert_statement_line, target_columns: target_columns).process }
    # TODO: use mock instead of real object or refactoring
    let(:target_columns) { Masking::Config::TargetColumns.new(config_fixture_path) }

    context 'when input InsertStatement Line is NOT target_table' do
      let(:insert_statement_line) { insert_statement_fixture('dummy_table.sql') }

      it { is_expected.to eq(insert_statement_line) }
    end

    context 'when input InsertStatement Line is target_table' do
      context 'when input InsertStatement Line has target_column' do
        let(:insert_statement_line) { insert_statement_fixture }

        it { is_expected.to eq insert_statement_fixture('sample_masked.sql') }
      end

      context 'when input InsertStatement Line does NOT have target_column' do
        let(:insert_statement_line) { insert_statement_fixture('dummy_columns.sql') }

        it { is_expected.to eq(insert_statement_line) }
      end
    end
  end

  describe '#target_table?' do
    subject { described_class.new(insert_statement_line, target_columns: target_columns).target_table? }

    let(:insert_statement_line) { insert_statement_fixture }
    let(:target_columns) { instance_double(Masking::Config::TargetColumns, 'contains?': stub_target_columns_return) }

    context 'table is defined in target_columns' do
      let(:stub_target_columns_return) { true }

      it { is_expected.to be true }
    end

    context 'table is NOT defined in target_columns' do
      let(:stub_target_columns_return) { false }

      it { is_expected.to be false }
    end
  end
end
