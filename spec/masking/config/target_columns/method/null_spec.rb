# frozen_string_literal: true

require 'masking/config/target_columns/method/null'

RSpec.describe Masking::Config::TargetColumns::Method::Null do
  describe '#call' do
    subject { described_class.new(value).call }

    let(:value) { nil }

    it { is_expected.to eq 'NULL' }
  end
end
