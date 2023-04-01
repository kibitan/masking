# frozen_string_literal: true

require 'spec_helper'

require 'masking/config/target_columns/method/methodable'
require 'masking/config/target_columns/method/ignore_null'

RSpec.describe Masking::Config::TargetColumns::Method::IgnoreNull do
  before do
    class MethodObject
      include Masking::Config::TargetColumns::Method::Methodable

      def call(_sql_value)
        'original call'
      end
    end
  end

  describe '#call' do
    let(:prepended_object) { MethodObject.new('mask_value').tap { |obj| obj.singleton_class.prepend(described_class) } }
    subject { prepended_object.call(sql_value) }

    context 'when NULL' do
      let(:sql_value) { 'NULL' }

      it { is_expected.to eq 'NULL' }
    end

    context 'when abc' do
      let(:sql_value) { 'abc' }

      it { is_expected.to eq 'original call' }
    end
  end
end
