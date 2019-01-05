# frozen_string_literal: true

require 'spec_helper'

require 'masking/config/target_columns/method/string'

RSpec.describe Masking::Config::TargetColumns::Method::String do
  describe '#call' do
    subject { described_class.new(value).call }

    context 'when "hoge"' do
      let(:value) { 'hoge' }

      it { is_expected.to eq "'hoge'" }
    end

    context 'when "あああ"' do
      let(:value) { 'あああ' }

      it { is_expected.to eq "'あああ'".b }
    end

    # rubocop:disable Style/FormatStringToken
    context 'with sequential number placeholder %{n}' do
      subject { described_class.new(value) }

      let(:value) { 'number%{n}' }

      it 'increment number each by call' do
        expect(subject.call).to eq "'number1'"
        expect(subject.call).to eq "'number2'"
        expect(subject.call).to eq "'number3'"
      end
    end
    # rubocop:enable Style/FormatStringToken
  end
end
