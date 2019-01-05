# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Masking do
  it 'has a version number' do
    expect(Masking::VERSION).not_to be nil
  end

  describe '.run' do
    subject { described_class.run }

    it 'call Main.new.run' do
      expect(Masking::Main).to receive_message_chain(:new, :run)

      expect { subject }.not_to raise_error
    end
  end

  describe Masking::Main do
    describe '#run' do
      subject { described_class.new(input: input).run }

      context "with input: 'string'" do
        let(:input) { StringIO.new('string') }

        it "output 'string' to STDOUT" do
          expect { subject }.to output('string').to_stdout
        end
      end
    end
  end
end
