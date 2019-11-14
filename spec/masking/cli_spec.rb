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

      it 'exit status is 0' do
        $stdout = File.new(File::NULL, 'w')
        subject
      rescue SystemExit => e
        expect(e.status).to eq(0)
      ensure
        $stdout = STDOUT
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
      before do
        allow(Masking).to receive(:run)
          .and_raise(raising_error)
      end
      let(:argv) { [] }

      shared_examples 'with errormessage and exitstatus is 1' do |error_text|
        it do
          expect { subject }.to raise_error(SystemExit) & \
                                output(error_text).to_stderr
        end

        it 'exit status is 1' do
          $stdout = File.new(File::NULL, 'w')
          subject
        rescue SystemExit => e
          expect(e.status).to eq(1)
        ensure
          $stdout = STDOUT
        end
      end

      context 'raise Masking::Config::TargetColumns::FileDoesNotExist' do
        let(:raising_error) { Masking::Error::ConfigFileDoesNotExist }

        it_behaves_like 'with errormessage and exitstatus is 1', \
                        "ERROR: config file (masking.yml) does not exist\n"
      end

      context 'raise Masking::Config::TargetColumns::FileDoesNotExist' do
        let(:raising_error) { Masking::Error::ConfigFileIsNotFile }

        it_behaves_like 'with errormessage and exitstatus is 1', \
                        "ERROR: config file (masking.yml) is not file\n"
      end

      context 'raise Masking::Config::TargetColumns::ConfigFileIsNotValidYaml' do
        let(:raising_error) { Masking::Error::ConfigFileIsNotValidYaml }

        it_behaves_like 'with errormessage and exitstatus is 1', \
                        "ERROR: config file (masking.yml) is not valid yaml format\n"
      end
    end
  end
end
