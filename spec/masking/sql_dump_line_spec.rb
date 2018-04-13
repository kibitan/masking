require "masking/sql_dump_line"

RSpec.describe Masking::SQLDumpLine do
  DATALINE = %Q|INSERT INTO `users` (`id`, `name`, `email`, `password_digest`, `created_at`, `updated_at`) VALUES (1,'Chikahiro','kibitan@example.com','password_digest','2018-03-14 00:00:00','2018-03-29 00:00:00');|.freeze

  describe '#output' do
    subject { described_class.new(line).output }

    shared_examples 'should same with line' do
      it { is_expected.to eq line }
    end

    context "when line is NOT data line" do
      context "empty" do
        let(:line) { "" }

        it_behaves_like 'should same with line'
      end

      context "headline" do
        let(:line) { %Q|-- MySQL dump 10.13  Distrib 5.7.21, for osx10.13 (x86_64)| }

        it_behaves_like 'should same with line'
      end

      context "metadata" do
        let(:line) { %Q|/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;| }

        it_behaves_like 'should same with line'
      end

      context "DDL" do
        let(:line) { %Q|DROP TABLE IF EXISTS `users`;| }

        it_behaves_like 'should same with line'
      end
    end

    context "when line is data line" do
      let(:line) { DATALINE }

      it 'call Dataline' do
        expect(Masking::DataLine).to receive(:new).with(line)

        expect { subject }.not_to raise_error
      end
    end

    describe '#data_line?' do
      subject { described_class.new(line).send(:data_line?) }

      context "when line is NOT data line" do
        context "empty" do
          let(:line) { "" }

          it { is_expected.to eq false }
        end

        context "headline" do
          let(:line) { %Q|-- MySQL dump 10.13  Distrib 5.7.21, for osx10.13 (x86_64)| }

          it { is_expected.to eq false }
        end
      end

      context "when line is data line" do
        let(:line) { DATALINE }

        it { is_expected.to eq true }
      end
    end
  end
end
