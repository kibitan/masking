# frozen_string_literal: true

require 'spec_helper'
require 'masking/config/target_columns/method/methodable'

RSpec.describe Masking::Config::TargetColumns::Method::Methodable do
  describe '#value' do
    context 'when initialized with abc' do
      let(:methodable) { Class.new { include Masking::Config::TargetColumns::Method::Methodable }.new('abc') }

      it 'returns abc' do
        expect(methodable.instance_variable_get(:@value)).to eq('abc')
      end
    end
  end

  describe '#call' do
    let(:methodable) { Class.new { include Masking::Config::TargetColumns::Method::Methodable }.new('test') }

    it 'raises NotImplementedError' do
      expect { methodable.call('sql_value') }.to raise_error(NotImplementedError)
    end
  end
end
