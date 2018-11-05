# frozen_string_literal: true

require 'masking/config/target_columns/method'

RSpec.describe Masking::Config::TargetColumns::Method do
  describe '.new' do
    subject { Masking::Config::TargetColumns::Method.new(method) }

    context 'when String' do
      let(:method) { 'string' }

      it do
        expect(Masking::Config::TargetColumns::Method::StringBinaryDistinctor).to receive(:new).with('string')
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

    context 'when date' do
      let(:method) { Date.new(2018, 3, 14) }

      it do
        expect(Masking::Config::TargetColumns::Method::Date).to receive(:new).with(Date.new(2018, 3, 14))
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

    context 'when true' do
      let(:method) { true }

      it do
        expect(Masking::Config::TargetColumns::Method::Boolean).to receive(:new).with(true)
        subject
      end
    end

    context 'when false' do
      let(:method) { false }

      it do
        expect(Masking::Config::TargetColumns::Method::Boolean).to receive(:new).with(false)
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

    context 'unhappy path: Unknown type' do
      let(:method) { NotImplementedError }

      it { expect { subject }.to raise_error(Masking::Config::TargetColumns::Method::UnknownType) }
    end
  end

  describe '#call' do
    subject { Masking::Config::TargetColumns::Method.new(nil).call }

    it 'delegate to concreate object' do
      expect(Masking::Config::TargetColumns::Method::Null).to receive(:new).with(nil).and_return(
        instance_double(Masking::Config::TargetColumns::Method::Null).tap do |double|
          expect(double).to receive(:call)
        end
      )
      subject
    end
  end
end
