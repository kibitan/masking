# frozen_string_literal: true

require 'spec_helper'

require 'masking/data_mask_processor'

RSpec.describe Masking::DataMaskProcessor::Cache do
  describe '.fetch&.store' do
    subject { described_class.fetch(key) }
    let(:key) { 'sample key' }

    context 'there is no cache(store)' do
      it { is_expected.to eq nil }
    end

    context 'there is a cache(store)' do
      it do
        expect(described_class.store('sample key', 'sample value')).to eq 'sample value'
        is_expected.to eq 'sample value'
      end
    end
  end
end
