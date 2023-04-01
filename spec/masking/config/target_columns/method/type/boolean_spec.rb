# frozen_string_literal: true

require 'spec_helper'

require 'masking/config/target_columns/method/type/integer'

RSpec.describe Masking::Config::TargetColumns::Method::Type::Boolean do
  describe '#call' do
    subject { described_class.new(value).call('sql_value') }

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
