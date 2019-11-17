# frozen_string_literal: true

require 'spec_helper'

require 'masking/data_mask_processor'

RSpec.describe Masking::DataMaskProcessor::Cache do
  describe '.fetch_or_store_if_no_cache' do
    subject { described_class.fetch_or_store_if_no_cache(table: 'sample_table', proc: proc { 'sample_value' }) }
    before { described_class.clear }

    context 'there is no cache' do
      it { is_expected.to eq 'sample_value' }
    end

    context 'if there is a cache' do
      before { described_class.fetch_or_store_if_no_cache(table: 'sample_table', proc: proc { 'cached_value' }) }

      it { is_expected.to eq 'cached_value' }
    end
  end
end
