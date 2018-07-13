# frozen_string_literal: true

require 'masking/insert_statement'

RSpec.describe Masking::InsertStatement do
  let(:raw_line) { insert_statement_fixture }

  describe '#table' do
    subject { described_class.new(raw_line).table }

    it { is_expected.to eq 'users' }
  end

  describe '#columns' do
    subject { described_class.new(raw_line).columns }

    it { is_expected.to eq %i[id name email password_digest created_at updated_at] }
  end

  describe '#sql' do
    subject { described_class.new(raw_line).sql }

    it 'call SQLBuilder' do
      expect(Masking::InsertStatement::SQLBuilder).to receive(:build).with(
        table:  'users',
        columns: %i[id name email password_digest created_at updated_at],
        values: [
          instance_of(Masking::InsertStatement::Value),
          instance_of(Masking::InsertStatement::Value)
        ]
      )
      subject
    end
  end

  describe '#values_regexp' do
    subject { described_class.new(raw_line).send(:values_regexp) }

    it 'returns dynamic regexp' do
      is_expected.to eq /\((.*?),(.*?),(.*?),(.*?),(.*?),(.*?)\),?/
    end
  end

  describe '#values' do
    subject { described_class.new(raw_line).values }

    it 'returns array of InsertStatement::Value' do
      is_expected.to match_array [
        Masking::InsertStatement::Value.new(
          columns: %i[id name email password_digest created_at updated_at],
          data: ['1', "'Super Chikahiro'", "'kibitan@example.com'", "'password_digest'", "'2018-03-14 00:00:00'", "'2018-03-29 00:00:00'"]
        ),
        Masking::InsertStatement::Value.new(
          columns: %i[id name email password_digest created_at updated_at],
          data: ['2', "'Super Tokoro'", "'kibitan++@example.com'", "'password_digest2'", "'2018-04-01 00:00:00'", "'2018-04-03 12:00:00'"]
        )
      ]
    end
  end
end
