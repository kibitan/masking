require "masking/config/target_columns/table"

RSpec.describe Masking::Config::TargetColumns::Table do
  describe '#name' do
    subject { described_class.new(name).name }
    let(:name) { 'sample_table' }

    it { is_expected.to eq :sample_table }
  end
end
