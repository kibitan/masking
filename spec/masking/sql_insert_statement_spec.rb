require "masking/sql_insert_statement"

RSpec.describe Masking::SQLInsertStatement do
  ## TODO: extract defination to factory, duplicate with SQLDumpLine spec
  let(:raw_line) { %Q|INSERT INTO `users` (`id`, `name`, `email`, `password_digest`, `created_at`, `updated_at`) VALUES (1,'Super Chikahiro','kibitan@example.com','password_digest','2018-03-14 00:00:00','2018-03-29 00:00:00'),(2,'Super Tokoro','kibitan++@example.com','password_digest2','2018-04-01 00:00:00','2018-04-03 12:00:00');| }

  describe '#mask' do
    subject { described_class.new(raw_line).mask }

    pending 'not implemented yet'
  end

  describe '#table_name' do
    subject { described_class.new(raw_line).table_name }

    it { is_expected.to eq 'users' }
  end

  describe '#columns' do
    subject { described_class.new(raw_line).columns }

    it { is_expected.to eq %w(id name email password_digest created_at updated_at) }
  end

  describe '#target_table?' do
    subject { described_class.new(raw_line, target_columns: target_columns).target_table? }

    context 'table is defined in target_columns' do
      # TODO: define factory
      let(:target_columns) { Masking::Config::TargetColumns.new(Pathname('spec/masking/config/dummy_files/target_columns.yml')) }
      it { is_expected.to be true }
    end

    context 'table is NOT defined in target_columns' do
      # TODO: define factory
      let(:target_columns) { Masking::Config::TargetColumns.new(Pathname('spec/masking/config/dummy_files/address_target_columns.yml')) }
      it { is_expected.to be false }
    end
  end

  describe '#values' do
    subject { described_class.new(raw_line).values }

    it 'returns values' do
      is_expected.to match_array [
        ["1","'Super Chikahiro'","'kibitan@example.com'","'password_digest'","'2018-03-14 00:00:00'","'2018-03-29 00:00:00'"],
        ["2","'Super Tokoro'","'kibitan++@example.com'","'password_digest2'","'2018-04-01 00:00:00'","'2018-04-03 12:00:00'"]
      ]
    end
  end

  describe '#values_regexp' do
    subject { described_class.new(raw_line).send(:values_regexp) }

    it 'returns dynamic regexp' do
      is_expected.to eq /\((.*?),(.*?),(.*?),(.*?),(.*?),(.*?)\),?/
    end
  end
end
