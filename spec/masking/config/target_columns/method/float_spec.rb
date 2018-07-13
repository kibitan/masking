# frozen_string_literal: true

require 'masking/config/target_columns/method/float'

RSpec.describe Masking::Config::TargetColumns::Method::Float do
  describe '#call' do
    subject { described_class.new(value).call }

    context 'when 1.2345' do
      let(:value) { 1.2345 }

      it { is_expected.to eq '1.2345' }
    end

    context 'when 1234.500' do
      let(:value) { 1234.500 }

      it { is_expected.to eq '1234.5' }
    end
  end
end
