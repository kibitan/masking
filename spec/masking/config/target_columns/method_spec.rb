require "masking/config/target_columns/method"

RSpec.describe Masking::Config::TargetColumns::Method do
  describe '#new' do
    subject { Masking::Config::TargetColumns::Method.new(method) }

    context 'when String' do
      let(:method) { 'string' }

      it do
        expect(Masking::Config::TargetColumns::Method::String).to receive(:new).with('string')
        subject
      end
    end

    context 'when Integer' do
      let(:method) { 123 }

      it do
        expect(Masking::Config::TargetColumns::Method::Integer).to receive(:new).with(123)
        subject
      end
    end

    context 'when Float' do
      let(:method) { 123.456 }

      it do
        expect(Masking::Config::TargetColumns::Method::Float).to receive(:new).with(123.456)
        subject
      end
    end

    context 'when time' do
      let(:method) { Time.new(2018, 3, 14, 15, 31, 0) }

      it do
        expect(Masking::Config::TargetColumns::Method::Time).to receive(:new).with(Time.new(2018, 3, 14, 15, 31, 0))
        subject
      end
    end

    context 'when nil' do
      let(:method) { nil }

      it do
        expect(Masking::Config::TargetColumns::Method::Null).to receive(:new).with(nil)
        subject
      end
    end
  end
end
