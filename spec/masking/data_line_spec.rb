require "masking/data_line"

RSpec.describe Masking::DataLine do
  ## TODO: extract defination to factory, duplicate with SQLDumpLine spec
  let(:raw_line) { %Q|INSERT INTO `users` (`id`, `name`, `email`, `password_digest`, `created_at`, `updated_at`) VALUES (1,'Chikahiro','kibitan@example.com','password_digest','2018-03-14 00:00:00','2018-03-29 00:00:00');| }

  describe '#mask' do
    subject { described_class.new(data_line).mask }

    pending 'making'
  end

  describe '#table_name' do
    subject { described_class.new(raw_line).table_name }

    it { is_expected.to eq :users }
  end

  describe '#columns' do
    subject { described_class.new(raw_line).columns }

    it { is_expected.to eq %i(id name email password_digest created_at updated_at) }
  end

  describe '#target_table?' do
    subject { described_class.new(raw_line, target_columns: target_columns).target_table? }

    context 'table is defined in target_columns' do
      let(:target_columns) do
        {
          users: {
            name: 'name'
          }
        }
      end
      it { is_expected.to be true }
    end

    context 'table is NOT defined in target_columns' do
      let(:target_columns) { Hash.new }

      it { is_expected.to be false }
    end
  end
end
