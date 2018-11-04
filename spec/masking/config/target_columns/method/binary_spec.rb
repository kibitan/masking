# frozen_string_literal: true

require 'masking/config/target_columns/method/binary'

RSpec.describe Masking::Config::TargetColumns::Method::Binary do
  describe '#call' do
    subject { described_class.new(value).call }

    context 'binary string (only ascii)' do
      let(:value) { 'only ascii binary' }

      it { is_expected.to eq "_binary 'only ascii binary'" }
      # TODO: should put with Encoding::ASCII_8BIT
      # it('encoding in ascii 8bit') { expect(subject.encoding).to eq Encoding::ASCII_8BIT }
      it('encoding in utf-8') { expect(subject.encoding).to eq Encoding::UTF_8 }
    end

    context 'binary string (non ascii)' do
      let(:value) { "\x92".b }

      # TODO: should put with Encoding::ASCII_8BIT
      # it { is_expected.to eq "_binary '\x92'".b }
      # it('encoding in ascii 8bit') { expect(subject.encoding).to eq Encoding::ASCII_8BIT }
      it { is_expected.to eq "_binary '\x92'" }
      it('encoding in utf-8') { expect(subject.encoding).to eq Encoding::UTF_8 }
    end

    context 'empty binary' do
      let(:value) { ''.b }

      it { is_expected.to eq "_binary ''" }
      # TODO: should put with Encoding::ASCII_8BIT
      # it('encoding in ascii 8bit') { expect(subject.encoding).to eq Encoding::ASCII_8BIT }
      it('encoding in utf-8') { expect(subject.encoding).to eq Encoding::UTF_8 }
    end
  end
end
