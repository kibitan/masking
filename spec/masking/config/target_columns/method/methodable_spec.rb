# frozen_string_literal: true

require 'spec_helper'

require 'masking/config/target_columns/method/methodable'

RSpec.describe Masking::Config::TargetColumns::Method::Methodable do
  before do
    class TestObject
      include Masking::Config::TargetColumns::Method::Methodable
    end
  end

  describe '#value' do
    subject { TestObject.new(value).instance_variable_get(:@value) }

    context 'when abc' do
      let(:value) { "abc" }

      it { is_expected.to eq("abc") }
    end
  end

  describe '#call' do
    subject { TestObject.new("test").call }

    it 'raise error' do
      expect { subject }.to raise_error NotImplementedError
    end
  end
end
