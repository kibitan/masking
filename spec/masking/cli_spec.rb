RSpec.describe Masking::Cli do
  describe '#mask' do
    subject { Masking::Cli.new.mask }

    it 'call Main.run' do
      expect(Masking).to receive(:run)

      expect { subject }.not_to raise_error
    end

    pending 'receive from STDIN and write to OUTPUT'
  end
end
