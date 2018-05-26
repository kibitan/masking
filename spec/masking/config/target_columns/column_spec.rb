require "masking/config/target_columns/column"

RSpec.describe Masking::Config::TargetColumns::Column do
  describe '#name' do
    subject { described_class.new(name).name }
    let(:name) { 'sample_column' }

    it { is_expected.to eq :sample_column }
  end
end
