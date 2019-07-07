# frozen_string_literal: true

require 'spec_helper'

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

    shared_examples 'print Version and exit' do
      it do
        expect { subject }.to raise_error(SystemExit) & \
                              output(Masking::VERSION + "\n").to_stdout
      end
    end

    context 'with option `-v`' do
      let(:argv) { ['-v'] }

      it_behaves_like 'print Version and exit'
    end

    context 'with option `--version`' do
      let(:argv) { ['--version'] }

      it_behaves_like 'print Version and exit'
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
                                output("ERROR: config file (masking.yml) does not exist\n").to_stderr
        end
      end

      context 'raise Masking::Config::TargetColumns::FileDoesNotExist' do
        before do
          allow(Masking).to receive(:run)
            .and_raise(Masking::Error::ConfigFileIsNotFile)
        end

        it do
          expect { subject }.to raise_error(SystemExit) & \
                                output("ERROR: config file (masking.yml) is not file\n").to_stderr
        end
      end

      context 'raise Masking::Config::TargetColumns::ConfigFileIsNotValidYaml' do
        before do
          allow(Masking).to receive(:run)
            .and_raise(Masking::Error::ConfigFileIsNotValidYaml)
        end

        it do
          expect { subject }.to raise_error(SystemExit) & \
                                output("ERROR: config file (masking.yml) is not valid yaml format\n").to_stderr
        end
      end
    end
  end
end
