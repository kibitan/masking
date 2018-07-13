require "masking/config/target_columns/method/time"

RSpec.describe Masking::Config::TargetColumns::Method::Time do
  describe '#call' do
    subject { described_class.new(value).call }

    context 'when 2018-03-20 18:15:30' do
      let(:value) { Time.new(2018, 3, 20, 18, 15, 30) }

      it { is_expected.to eq "'2018-03-20 18:15:30'" }
    end
  end
end
