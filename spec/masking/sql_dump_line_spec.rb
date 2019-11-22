# frozen_string_literal: true

require 'spec_helper'

require 'masking/sql_dump_line'

RSpec.describe Masking::SQLDumpLine do
  describe '#mask' do
    subject { described_class.new(line, mask_processor: mask_processor).mask }
    let(:mask_processor) { class_double(Masking::DataMaskProcessor) }

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
      subject { described_class.new(line, mask_processor: mask_processor).mask }
      let(:line) { insert_statement_fixture }
      let(:mask_processor) do
        data_mask_processor = instance_double(Masking::DataMaskProcessor)
        expect(data_mask_processor).to receive(:process).and_return(line)
        class_double(Masking::DataMaskProcessor, new: data_mask_processor)
      end

      it_behaves_like 'should be same with line'

      context 'including invalid utf8 char' do
        let(:line) { insert_statement_fixture('with_binary.sql') }

        it_behaves_like 'should be same with line'
      end
    end
  end

  describe '#insert_statement?' do
    subject { described_class.new(line, mask_processor: mask_processor).insert_statement? }
    let(:mask_processor) { class_double(Masking::DataMaskProcessor) }

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
