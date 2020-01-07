# frozen_string_literal: true

require 'spec_helper'

require 'masking/config/mask_columns/method/date'

RSpec.describe Masking::Config::MaskColumns::Method::Date do
  describe '#call' do
    subject { described_class.new(value).call }

    context 'when 2018-07-20' do
      let(:value) { Date.new(2018, 7, 20) }

      it { is_expected.to eq "'2018-07-20'" }
    end
  end
end
