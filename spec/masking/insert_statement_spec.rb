# frozen_string_literal: true

require 'spec_helper'
require 'masking/insert_statement'

RSpec.describe Masking::InsertStatement do
  subject { described_class.new(raw_line, sql_builder: sql_builder) }

  let(:raw_line) { insert_statement_fixture }
  let(:sql_builder) do
    class_double(
      Masking::InsertStatement::SQLBuilder,
      new: instance_double(Masking::InsertStatement::SQLBuilder, sql: 'dummy sql')
    )
  end

  describe '#table' do
    it { expect(subject.table).to eq 'users' }
  end

  describe '#columns' do
    it { expect(subject.columns).to eq %i[id name email password_digest created_at updated_at] }
  end

  describe '#column_index' do
    subject { described_class.new(raw_line, sql_builder: sql_builder).column_index(column_name) }

    context 'with contains column name' do
      let(:column_name) { :password_digest }

      it { is_expected.to eq 3 }
    end

    context 'without contains column name' do
      let(:column_name) { 'hoge' }

      it { is_expected.to eq nil }
    end
  end

  describe '#sql' do
    before do
      expect(sql_builder).to receive(:new).with(
        table: 'users',
        columns: %i[id name email password_digest created_at updated_at],
        values: [
          instance_of(Array),
          instance_of(Array)
        ]
      )
    end

    it 'call SQLBuilder' do
      expect { subject.sql }.not_to raise_error
    end
  end

  # rubocop:disable Metrics/LineLength
  describe '#mask_value' do
    subject { described_class.new(raw_line).mask_value(column_index: column_index, mask_method: mask_method) }

    let(:column_index) { 2 }
    let(:mask_method) { double(call: "'masked_email@email.com'") }

    it {
      is_expected.to match_array [
        ['1', "'Super Chikahiro'", "'masked_email@email.com'", "'password_digest'", "'2018-03-14 00:00:00'", "'2018-03-29 00:00:00'"],
        ['2', "'Super Tokoro'", "'masked_email@email.com'", "'password_digest2'", "'2018-04-01 00:00:00'", "'2018-04-03 12:00:00'"]
      ]
    }

    context 'with not containing column_name' do
      let(:column_index) { nil }

      # it { expect { subject }.to raise_error Masking::InsertStatement::NoMathingColumn }
      it { is_expected.to eq nil }
    end
  end

  describe '#values' do
    subject { described_class.new(raw_line, sql_builder: sql_builder).values }

    it 'returns array of InsertStatement::Value' do
      is_expected.to match_array [
        ['1', "'Super Chikahiro'", "'kibitan@example.com'", "'password_digest'", "'2018-03-14 00:00:00'", "'2018-03-29 00:00:00'"],
        ['2', "'Super Tokoro'", "'kibitan++@example.com'", "'password_digest2'", "'2018-04-01 00:00:00'", "'2018-04-03 12:00:00'"]
      ]
    end

    context 'with comma and bracket in value' do
      let(:raw_line) { insert_statement_fixture('comma_and_bracket_and_single_quote_and_empty_string_and_null_in_value.sql') }

      it 'returns array of InsertStatement::Value' do
        is_expected.to match_array [
          ['1.23', "'comma ,,, and bracket () and single quote \\'   and particular patten ),( and finished on backslash \\\\'", "'kibitan@example.com'"],
          ['-2.5', "''", 'NULL']
        ]
      end
    end

    context 'with bracket and comman more than once in value' do
      let(:raw_line) { insert_statement_fixture('bracket_and_comma_appears_more_than_once.sql') }

      it 'returns array of InsertStatement::Value' do
        is_expected.to match_array [
          ['1', "'patten ),( and ),( more than once ),('", "'kibitan2@example.com'"],
          ['-2', "'single quote \\' also appear '", 'NULL']
        ]
      end
    end

    context 'string seated in last order of columns and include apostrophe and ending parenthesis' do
      let(:raw_line) { insert_statement_fixture('string_include_parenthesis.sql') }

      it 'returns array of InsertStatement::Value' do
        is_expected.to match_array [
          ['1', "'sample text'", %q|'last order of columns and include apostrophe and ending parenthesis \') \') \') this pattern can be wrong'|],
          ['2', "'sample text 2'", "'test text 2'"]
        ]
      end
    end

    context 'with Scientific notation in value' do
      let(:raw_line) { insert_statement_fixture('number_with_scientific_notation.sql') }

      it 'returns array of InsertStatement::Value' do
        is_expected.to match_array [
          ['9.71726e-17', '1e+030', 'NULL'],
          ['1.2E3', '-1.2E-3', "'test string'"]
        ]
      end
    end

    context 'with binary type' do
      let(:raw_line) { insert_statement_fixture('with_binary_type.sql') }

      it 'returns array of InsertStatement::Value' do
        is_expected.to match_array [
          ['1', "'sample text'", "_binary 'binarydata'", "_binary 'blob'", "'varchar2'", "'text text'", '123'],
          ['2', "'sample text 2'", "_binary 'binarydata 2'", "_binary 'blob 2'", "'varchar2 2'", "'text text text'", '1234']
        ]
      end
    end

    context 'binary type seated in last order of columns and include apostrophe and ending parenthesis' do
      let(:raw_line) { insert_statement_fixture('binary_type_include_parenthesis.sql') }

      it 'returns array of InsertStatement::Value' do
        is_expected.to match_array [
          ['1', "'sample text'", %q|_binary 'last order of columns and include apostrophe and ending parenthesis \') \') \') this pattern can be wrong'|],
          ['2', "'sample text 2'", "_binary 'test binary'"]
        ]
      end
    end

    context 'unhappy path' do
      shared_examples_for 'raises error InsertStatementParseError' do
        it 'raises error InsertStatementParseError' do
          expect { subject }.to raise_error(Masking::Error::InsertStatementParseError)
        end
      end

      context 'without --complete-insert-option statement' do
        let(:raw_line) { insert_statement_fixture('without_complete_insert_option.sql') }

        it_behaves_like 'raises error InsertStatementParseError'
      end

      context 'invalid insert statement' do
        let(:raw_line) { insert_statement_fixture('invalid_insert_statement.sql') }

        it_behaves_like 'raises error InsertStatementParseError'
      end
    end
  end
  # rubocop:enable Metrics/LineLength
end
