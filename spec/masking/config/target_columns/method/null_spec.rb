# frozen_string_literal: true

require 'spec_helper'

require 'masking/config/mask_columns/method/null'

RSpec.describe Masking::Config::MaskColumns::Method::Null do
  describe '#call' do
    subject { described_class.new(value).call }

    let(:value) { nil }

    it { is_expected.to eq 'NULL' }
  end
end
