# frozen_string_literal: true

require 'spec_helper'

require 'masking/config/mask_columns/method/string_binary_distinctor'

RSpec.describe Masking::Config::MaskColumns::Method::StringBinaryDistinctor do
  describe '.new' do
    subject { described_class.new(arg) }

    context 'argument is string' do
      let(:arg) { 'string' }

      it { is_expected.to be_instance_of Masking::Config::MaskColumns::Method::String }
    end

    context 'binary string (only ascii)' do
      let(:arg) { 'aiueo'.b }

      it { is_expected.to be_instance_of Masking::Config::MaskColumns::Method::Binary }
    end

    context 'argument is binary (non ascii)' do
      let(:arg) { "\x00\x92".b }

      it { is_expected.to be_instance_of Masking::Config::MaskColumns::Method::Binary }
    end
  end
end
