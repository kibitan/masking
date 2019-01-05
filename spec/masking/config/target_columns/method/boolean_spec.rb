# frozen_string_literal: true

require 'spec_helper'

require 'masking/config/target_columns/method/boolean'

RSpec.describe Masking::Config::TargetColumns::Method::Boolean do
  describe '#call' do
    subject { described_class.new(value).call }

    context 'when false' do
      let(:value) { false }

      it { is_expected.to eq '0' }
    end

    context 'when true' do
      let(:value) { true }

      it { is_expected.to eq '1' }
    end
  end
end
