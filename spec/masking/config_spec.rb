# frozen_string_literal: true

RSpec.describe Masking::Config do
  describe '.target_columns_file_path' do
    subject { described_class.target_columns_file_path }

    context 'setting with default' do
      it { is_expected.to eq Pathname('target_columns.yml') }
    end
  end

  describe '.target_columns_file_path=' do
    subject { described_class.target_columns_file_path = target_columns_file_path }
    let(:target_columns_file_path) { 'changed_target_columns.yml' }

    it 'set target_columns_file_path' do
      subject
      expect(described_class.target_columns_file_path).to eq Pathname('changed_target_columns.yml')
    end
  end

  describe '.target_columns' do
    subject { described_class.target_columns }

    it 'return Masking::Config::TargetColumns' do
      # TODO: get rid of Singleton for side-effect of global variable
      # expect(Masking::Config::TargetColumns).to receive(:new).with(Pathname('changed_target.yml'))
      expect(Masking::Config::TargetColumns).to receive(:new).with(Pathname('changed_target_columns.yml'))
      subject
    end
  end
end
