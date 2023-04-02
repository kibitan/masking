# frozen_string_literal: true

require 'spec_helper'

require 'masking/config/target_columns/method/string_binary_distinctor'

RSpec.describe Masking::Config::TargetColumns::Method::StringBinaryDistinctor do
  describe '.new' do
    subject { described_class.new(arg) }

    context 'with argument is string' do
      let(:arg) { 'string' }

      it { is_expected.to be_instance_of Masking::Config::TargetColumns::Method::Type::String }
    end

    context 'with binary string (only ascii)' do
      let(:arg) { 'aiueo'.b }

      it { is_expected.to be_instance_of Masking::Config::TargetColumns::Method::Type::Binary }
    end

    context 'with argument is binary (non ascii)' do
      let(:arg) { "\x00\x92".b }

      it { is_expected.to be_instance_of Masking::Config::TargetColumns::Method::Type::Binary }
    end
  end
end
