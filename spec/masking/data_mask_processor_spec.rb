require "masking/data_mask_processor"

RSpec.describe Masking::DataMaskProcessor do
  describe ".process" do
    subject { described_class.process(sql_insert_statement_line) }
    let(:sql_insert_statement_line) { :dummy }

    it { is_expected.to eq :dummy }
  end
end
