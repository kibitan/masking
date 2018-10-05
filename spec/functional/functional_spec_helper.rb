# frozen_string_literal: true

require 'open3'

def command_subject(command, stdin: '')
  subject { Open3.capture3(command, stdin_data: stdin) }

  let(:stdout) { subject[0] }
  let(:stderr) { subject[1] }
  let(:exitstatus) { subject[2].exitstatus }
end
