require "masking/config/target_columns/method/string"

RSpec.describe Masking::Config::TargetColumns::Method::String do
  describe '#call' do
    subject { described_class.new(value).call }

    context 'when "hoge"' do
      let(:value) { 'hoge' }

      it { is_expected.to eq "'hoge'" }
    end

    context 'when "あああ"' do
      let(:value) { 'あああ' }

      it { is_expected.to eq "'あああ'" }
    end
  end
end
