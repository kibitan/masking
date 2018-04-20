require "masking/config/target_columns"

RSpec.describe Masking::Config::TargetColumns do
  describe '.initialize' do
    subject { described_class.new }

    context "without argument(file_path)" do
      it 'contains default file_path' do
        # TODO: extract default file pathname definition
        expect(subject.file_path).to eq Pathname('config/target_columns.yml')
        expect(subject.send(:data)).not_to be_empty
        expect(subject.send(:data)).to be_a Hash
      end
    end
  end

  describe '.contains?' do
    context "arguments has just table_name" do
      subject { described_class.new(file_path).contains?(table_name: table_name) }
      # TODO: define factory for dummy_file
      let(:file_path) { Pathname('spec/masking/config/dummy_files/target_columns.yml') }

      context 'table_name is included in config yaml' do
        let(:table_name) { 'users' }

        it { is_expected.to eq true }
      end

      context 'table_name is NOT included in config yaml' do
        let(:table_name) { 'hogehoge' }

        it { is_expected.to eq false }
      end
    end
  end
end
