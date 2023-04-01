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

  describe '#call' do
    let(:sql_value) { 'NULL' }

    context 'when prepended with IgnoreNull' do
      let(:prepended_object) do
        methodable_class.new('mask_value').tap { |obj| obj.singleton_class.prepend(described_class) }
      end

      it 'returns NULL' do
        expect(prepended_object.call(sql_value)).to eq('NULL')
      end

      it 'does not affect another object' do
        prepended_object.call(sql_value)
        expect(methodable_class.new('mask_value').call(sql_value)).to eq('original call')
      end

      context 'when sequence! method is defined' do
        let(:methodable_class) do
          Class.new do
            include Masking::Config::TargetColumns::Method::Methodable

            def call(_sql_value)
              'original call'
            end

            private

            def sequence!; end
          end
        end

        it 'calls sequence! method' do
          expect(prepended_object).to receive(:sequence!)
          prepended_object.call(sql_value)
        end
      end
    end

    context 'when not prepended with IgnoreNull' do
      let(:not_prepended_object) do
        methodable_class.new('mask_value')
      end

      let(:sql_value) { 'abc' }

      it 'returns the original call' do
        expect(not_prepended_object.call(sql_value)).to eq('original call')
      end
    end
  end
end
