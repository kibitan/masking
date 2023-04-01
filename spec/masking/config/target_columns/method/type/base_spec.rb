# frozen_string_literal: true

require 'spec_helper'
require 'masking/config/target_columns/method/type/base'

RSpec.describe Masking::Config::TargetColumns::Method::Type::Base do
  describe '#value' do
    context 'when initialized with abc' do
      let(:type) { described_class.new('abc') }

      it 'returns abc' do
        expect(type.instance_variable_get(:@value)).to eq('abc')
      end
    end
  end

  describe '#call' do
    let(:type) { described_class.new('test') }

    it 'raises NotImplementedError' do
      expect { type.call('sql_value') }.to raise_error(NotImplementedError)
    end
  end
end
