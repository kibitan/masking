# frozen_string_literal: true

RSpec.describe Masking::Cli do
  describe '#run' do
    subject { Masking::Cli.new(argv).run }

    shared_examples 'set config and call Main.run' do
      it 'set config and call Main.run' do
        expect(Masking).to receive(:config).and_return(
          instance_double(Masking::Config).tap do |config|
            expect(config).to receive(:target_columns_file_path=).with('config.yml')
          end
        )
        expect(Masking).to receive(:run)

        subject
      end
    end

    context 'with option `-cconfig.yml`' do
      let(:argv) { ['-cconfig.yml'] }

      it_behaves_like 'set config and call Main.run'
    end

    context 'with option `-c config.yml`' do
      let(:argv) { ['-c', 'config.yml'] }

      it_behaves_like 'set config and call Main.run'
    end

    context 'with option `--config`' do
      let(:argv) { ['--config', 'config.yml'] }

      it_behaves_like 'set config and call Main.run'
    end

    context 'unhappy path' do
      let(:argv) { [] }

      context 'raise Masking::Config::TargetColumns::FileDoesNotExist' do
        before do
          allow(Masking).to receive(:run)
            .and_raise(Masking::Error::ConfigFileDoesNotExist)
        end

        it do
          expect { subject }.to raise_error(SystemExit) & \
                                output("ERROR: config file (target_columns.yml) does not exist\n").to_stderr
        end
      end

      context 'raise Masking::Config::TargetColumns::FileDoesNotExist' do
        before do
          allow(Masking).to receive(:run)
            .and_raise(Masking::Error::ConfigFileIsNotFile)
        end

        it do
          expect { subject }.to raise_error(SystemExit) & \
                                output("ERROR: config file (target_columns.yml) is not file\n").to_stderr
        end
      end
    end
  end
end
