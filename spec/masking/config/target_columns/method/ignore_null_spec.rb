# frozen_string_literal: true

require 'spec_helper'

require 'masking/config/target_columns/method/methodable'
require 'masking/config/target_columns/method/ignore_null'

RSpec.describe Masking::Config::TargetColumns::Method::IgnoreNull do
  let(:methodable_class) do
    Class.new do
      include Masking::Config::TargetColumns::Method::Methodable

      def call(_sql_value)
        'original call'
      end
    end
  end

  let(:prepended_object) do
    methodable_class.new('mask_value').tap { |obj| obj.singleton_class.prepend(described_class) }
  end

  describe '#call' do
    subject { prepended_object.call(sql_value) }

    context 'when NULL' do
      let(:sql_value) { 'NULL' }

      it 'returns NULL' do
        is_expected.to eq('NULL')
      end
    end

    context 'when not NULL' do
      let(:sql_value) { 'abc' }

      it 'returns the original call' do
        is_expected.to eq('original call')
      end
    end
  end
end
