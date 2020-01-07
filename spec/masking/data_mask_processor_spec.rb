# frozen_string_literal: true

require 'spec_helper'
require 'masking/data_mask_processor'

RSpec.describe Masking::DataMaskProcessor do
  describe '#process' do
    subject {
      described_class.new(
          insert_statement_line,
          mask_columns: target_columns,
          cache_store: cache_store
      ).process
    }
    class DummyCache
      def self.fetch_or_store_if_no_cache(table:, proc:) # rubocop:disable Lint/UnusedMethodArgument
        proc.call
      end
    end

    # TODO: use mock instead of real object or refactoring
    let(:mask_columns) { Masking::Config::TargetColumns.new(config_fixture_path) }
    let(:cache_store) { DummyCache }

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
end
