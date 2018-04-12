RSpec.describe Masking::Cli do
  describe '#execute' do
    subject { Masking::Cli.new.execute }

    it 'call Main.run' do
      expect(Masking).to receive(:run)

      expect { subject }.not_to raise_error
    end
  end
end
