# frozen_string_literal: true

require 'spec_helper'

require 'masking/config/target_columns/method/type/null'

RSpec.describe Masking::Config::TargetColumns::Method::Type::Null do
  describe '#call' do
    subject { described_class.new(value).call('sql_value') }

    let(:value) { nil }

    it { is_expected.to eq 'NULL' }
  end
end
