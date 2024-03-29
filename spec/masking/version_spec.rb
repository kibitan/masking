# frozen_string_literal: true

require 'masking/version'

RSpec.describe Masking::VERSION do
  it 'has a version number' do
    expect(Masking::VERSION).not_to be_nil # rubocop:disable RSpec/DescribedClass
  end
end
