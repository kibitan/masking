RSpec.describe Masking do
  it "has a version number" do
    expect(Masking::VERSION).not_to be nil
  end

  describe ".run" do
    subject { described_class.run }

    it "call Main.new.run" do
      expect_any_instance_of(Masking::Main).to receive(:run)

      expect { subject }.not_to raise_error
    end
  end

  describe Masking::Main do
    describe "#run" do
      subject { described_class.new.run }

      context "with STDIN: 'string'" do
        before { STDIN = "string" }

        it "output 'string' to STDOUT" do
          expect { subject }.to output('string').to_stdout
        end
      end
    end
  end
end
