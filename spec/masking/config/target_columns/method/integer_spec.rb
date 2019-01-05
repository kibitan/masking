# frozen_string_literal: true

require 'spec_helper'

require 'masking/config/target_columns/method/integer'

RSpec.describe Masking::Config::TargetColumns::Method::Integer do
  describe '#call' do
    subject { described_class.new(value).call }

    context 'when 12345' do
      let(:value) { 12_345 }

      it { is_expected.to eq '12345' }
    end

    context 'when -12' do
      let(:value) { -12 }

      it { is_expected.to eq '-12' }
    end
  end
end
