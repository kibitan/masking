# frozen_string_literal: true

require 'spec_helper'

require 'masking/config/target_columns/method/binary'

RSpec.describe Masking::Config::TargetColumns::Method::Binary do
  describe '#call' do
    subject { described_class.new(value).call('sql_value') }

    context 'binary string (only ascii)' do
      let(:value) { 'only ascii binary' }

      it { is_expected.to eq "_binary 'only ascii binary'" }
      it('encoding in ascii 8bit') { expect(subject.encoding).to eq Encoding::ASCII_8BIT }
    end

    context 'binary string (non ascii)' do
      let(:value) { "\x92".b }

      it { is_expected.to eq "_binary '\x92'".b }
      it('encoding in ascii 8bit') { expect(subject.encoding).to eq Encoding::ASCII_8BIT }
    end

    context 'empty binary' do
      let(:value) { ''.b }

      it { is_expected.to eq "_binary ''" }
      it('encoding in ascii 8bit') { expect(subject.encoding).to eq Encoding::ASCII_8BIT }
    end
  end
end
