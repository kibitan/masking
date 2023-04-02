# frozen_string_literal: true

require 'spec_helper'

require 'masking/config/target_columns/method/type/integer'

RSpec.describe Masking::Config::TargetColumns::Method::Type::Integer do
  describe '#call' do
    subject { described_class.new(value).call('sql_value') }

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
