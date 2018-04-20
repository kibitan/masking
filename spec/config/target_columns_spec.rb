require "masking/config/target_columns"

RSpec.describe Masking::Config::TargetColumns do
  describe '.initialize' do
    subject { described_class.new }

    context "without argument(file_path)" do
      it 'contains default file_path' do
        # TODO: extract default file pathname definition
        expect(subject.file_path).to eq Pathname('config/target_columns.yml')
      end
    end
  end
end
