# frozen_string_literal: true

require 'masking/insert_statement/sql_builder'

RSpec.describe Masking::InsertStatement::SQLBuilder do
  describe '.build' do
    subject { described_class.build(table: table, columns: columns, values: values) }
    let(:table) { 'users' }
    let(:columns) { %i[id name email address] }
    let(:values) do
      [
        instance_double(
          Masking::InsertStatement::Value,
          phrase: "(1,'John','john@example.com','berlin')"
        ),
        instance_double(
          Masking::InsertStatement::Value,
          phrase: "(2,'Super Chikahiro','kibitan++@example.com','tokyo')"
        )
      ]
    end

    # rubocop:disable Metrics/LineLength
    it { is_expected.to eq %|INSERT INTO `users` (`id`, `name`, `email`, `address`) VALUES (1,'John','john@example.com','berlin'),(2,'Super Chikahiro','kibitan++@example.com','tokyo');| }
    # rubocop:enable Metrics/LineLength
  end
end
