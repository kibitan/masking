# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Masking do
  describe '.run' do
    subject { described_class.run }

    it 'call Main.new.run' do
      expect(Masking::Main).to receive_message_chain(:new, :run)

      expect { subject }.not_to raise_error
    end
  end

  describe Masking::Main do
    describe '#run' do
      subject { described_class.new(input: input, output: _output, line_processor: line_processor).run }

      context "with input: 'string'" do
        let(:input) { StringIO.new('string') }
        let(:_output) { $stdout }
        let(:line_processor) { double(new: double(output: 'string')) }

        it "output 'string' to STDOUT" do
          expect { subject }.to output('string').to_stdout
        end
      end
    end
  end
end
