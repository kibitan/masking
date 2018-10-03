# frozen_string_literal: true

require 'open3'

RSpec.describe 'execute in command line' do
  context 'with target_columns.yml' do
    subject { Open3.capture3("masking -c #{config_fixture_path}", stdin_data: insert_statement_fixture) }

    # TODO: separate to test helper
    let(:stdout) { subject[0] }
    let(:stderr) { subject[1] }
    let(:exitstatus) { subject[2].exitstatus }

    it 'should masked correctly', :aggregate_failures do
      expect(stdout).to eq(insert_statement_fixture('sample_masked.sql'))
      expect(stderr).to be_empty
      expect(exitstatus).to eq(0)
    end
  end
end
