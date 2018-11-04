# frozen_string_literal: true

require 'masking/sql_dump_line'

RSpec.describe Masking::SQLDumpLine do
  describe '#output' do
    subject { described_class.new(line).output }

    shared_examples 'should be same with line' do
      it { is_expected.to eq line }
    end

    context 'when line is NOT insert statement line' do
      context 'empty' do
        let(:line) { '' }

        it_behaves_like 'should be same with line'
      end

      context 'headline' do
        let(:line) { sql_dump_line_fixture('headline.sql') }

        it_behaves_like 'should be same with line'
      end

      context 'metadata' do
        let(:line) { sql_dump_line_fixture('metadata.sql') }

        it_behaves_like 'should be same with line'
      end

      context 'DDL' do
        let(:line) { sql_dump_line_fixture('ddl.sql') }

        it_behaves_like 'should be same with line'
      end
    end

    context 'when line is insert statement' do
      let(:line) { insert_statement_fixture }

      it 'call DataMaskProcessor' do
        expect(Masking::DataMaskProcessor).to receive(:process).with(line)

        expect { subject }.not_to raise_error
      end
    end

    context 'when line is insert statement including invalid utf8 char' do
      let(:line) { insert_statement_fixture('with_binary.sql') }

      it 'call DataMaskProcessor' do
        expect(Masking::DataMaskProcessor).to receive(:process).with(line.b)

        expect { subject }.not_to raise_error
      end

      it_behaves_like 'should be same with line'
    end
  end

  describe '#insert_statement?' do
    subject { described_class.new(line).send(:insert_statement?) }

    context 'when line is NOT insert statement' do
      context 'empty' do
        let(:line) { '' }

        it { is_expected.to eq false }
      end

      context 'headline' do
        let(:line) { sql_dump_line_fixture('headline.sql') }

        it { is_expected.to eq false }
      end
    end

    context 'when line is insert statement' do
      let(:line) { insert_statement_fixture }

      it { is_expected.to eq true }
    end

    context 'when line is insert statement including invalid utf8 char' do
      let(:line) { insert_statement_fixture('with_binary.sql') }

      it { is_expected.to eq true }
    end
  end
end
