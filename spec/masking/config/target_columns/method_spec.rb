# frozen_string_literal: true

require 'spec_helper'

require 'masking/config/target_columns/method'
require 'masking/config/target_columns/method/ignore_null'

RSpec.describe Masking::Config::TargetColumns::Method do
  shared_examples_for 'with argument `ignore_null: true`' do
    context 'with argument `ignore_null: true`' do
      subject { described_class.new(method, ignore_null: true) }

      it {
        expect(
          subject.instance_variable_get(:@method_type)
            .singleton_class
            .ancestors
            .include?(Masking::Config::TargetColumns::Method::IgnoreNull)
        ).to be true
      }
    end
  end

  describe '.new' do
    subject { described_class.new(method) }

    context 'when String' do
      let(:method) { 'string' }

      it do
        expect(Masking::Config::TargetColumns::Method::Type::StringBinaryDistinctor).to receive(:new).with('string')
        subject
      end

      include_examples 'with argument `ignore_null: true`'
    end

    context 'when Integer' do
      let(:method) { 123 }

      it do
        expect(Masking::Config::TargetColumns::Method::Type::Integer).to receive(:new).with(123)
        subject
      end

      include_examples 'with argument `ignore_null: true`'
    end

    context 'when Float' do
      let(:method) { 123.456 }

      it do
        expect(Masking::Config::TargetColumns::Method::Type::Float).to receive(:new).with(123.456)
        subject
      end

      include_examples 'with argument `ignore_null: true`'
    end

    context 'when date' do
      let(:method) { Date.new(2018, 3, 14) }

      it do
        expect(Masking::Config::TargetColumns::Method::Type::Date).to receive(:new).with(Date.new(2018, 3, 14))
        subject
      end

      include_examples 'with argument `ignore_null: true`'
    end

    context 'when time' do
      let(:method) { Time.new(2018, 3, 14, 15, 31, 0) }

      it do
        expect(Masking::Config::TargetColumns::Method::Type::Time).to receive(:new).with(Time.new(2018, 3, 14, 15, 31,
                                                                                                  0))
        subject
      end

      include_examples 'with argument `ignore_null: true`'
    end

    context 'when true' do
      let(:method) { true }

      it do
        expect(Masking::Config::TargetColumns::Method::Type::Boolean).to receive(:new).with(true)
        subject
      end

      include_examples 'with argument `ignore_null: true`'
    end

    context 'when false' do
      let(:method) { false }

      it do
        expect(Masking::Config::TargetColumns::Method::Type::Boolean).to receive(:new).with(false)
        subject
      end

      include_examples 'with argument `ignore_null: true`'
    end

    context 'when nil' do
      let(:method) { nil }

      it do
        expect(Masking::Config::TargetColumns::Method::Type::Null).to receive(:new).with(nil)
        subject
      end

      include_examples 'with argument `ignore_null: true`'
    end

    context 'unhappy path: Unknown type' do
      let(:method) { NotImplementedError }

      it { expect { subject }.to raise_error(Masking::Config::TargetColumns::Method::UnknownType) }
    end
  end

  describe '#call' do
    subject { described_class.new(nil).call('_sql_value') }

    it 'delegate to concreate object' do
      expect(Masking::Config::TargetColumns::Method::Type::Null).to receive(:new).with(nil).and_return(
        instance_double(Masking::Config::TargetColumns::Method::Type::Null).tap do |double|
          expect(double).to receive(:call)
        end
      )
      subject
    end
  end
end
