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

  # rubocop:disable Metrics/LineLength
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

    context 'with comma and bracket in value' do
      let(:raw_line) { insert_statement_fixture('comma_and_bracket_and_single_quote_and_empty_string_and_null_in_value.sql') }

      it 'returns array of InsertStatement::Value' do
        is_expected.to match_array [
          Masking::InsertStatement::Value.new(
            columns: %i[float_id name email],
            data: ['1.23', "'comma ,,, and bracket () and single quote \\'\\' and particular patten ),( there you go!'", "'kibitan@example.com'"]
          ),
          Masking::InsertStatement::Value.new(
            columns: %i[float_id name email],
            data: ['-2.5', "''", 'NULL']
          )
        ]
      end
    end

    context 'with Scientific notation in value' do
      let(:raw_line) { insert_statement_fixture('number_with_scientific_notation.sql') }

      it 'returns array of InsertStatement::Value' do
        is_expected.to match_array [
          Masking::InsertStatement::Value.new(
            columns: %i[float1 float2 string],
            data: ['9.71726e-17', '1e+030', 'NULL']
          ),
          Masking::InsertStatement::Value.new(
            columns: %i[float1 float2 string],
            data: ['1.2E3', '-1.2E-3', "'test string'"]
          )
        ]
      end
    end

    context 'with binary type' do
      let(:raw_line) { insert_statement_fixture('with_binary_type.sql') }

      it 'returns array of InsertStatement::Value' do
        is_expected.to match_array [
          Masking::InsertStatement::Value.new(
            columns: %i[id varchar binary blob varchar2 text int],
            data: ['1', "'sample text'", "_binary 'binarydata'", "_binary 'blob'", "'varchar2'", "'text text'", '123']
          ),
          Masking::InsertStatement::Value.new(
            columns: %i[id varchar binary blob varchar2 text int],
            data: ['2', "'sample text 2'", "_binary 'binarydata 2'", "_binary 'blob 2'", "'varchar2 2'", "'text text text'", '1234']
          )
        ]
      end
    end

    context 'binary type seated in last order of columns and include apostrophe and ending parenthesis' do
      let(:raw_line) { insert_statement_fixture('binary_type_include_parenthesis.sql') }

      it 'returns array of InsertStatement::Value' do
        is_expected.tapp.to match_array [
          Masking::InsertStatement::Value.new(
            columns: %i[id varchar binary],
            data: ['1', "'sample text'", "_binary 'last order of columns and include apostrophe and ending parenthesis ') this pattern can be wrong'"]
          ),
          Masking::InsertStatement::Value.new(
            columns: %i[id varchar binary],
            data: ['2', "'sample text 2'", "_binary 'test binary'"]
          )
        ]
      end
    end
  end

  # rubocop:enable Metrics/LineLength
end
