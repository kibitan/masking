require "masking/config/target_columns"
require "masking/insert_statement"

module Masking
  # TODO: find better naming/modeling of DataMaskProcessor
  class DataMaskProcessor
    class << self
      def process(insert_statement_line, target_columns: Config::TargetColumns.new)
        new(insert_statement_line, target_columns: target_columns).send(:process)
      end
    end

    private

    attr_reader :raw_line, :target_columns, :insert_statement

    def initialize(insert_statement_line, target_columns:)
      @raw_line         = insert_statement_line
      @target_columns   = target_columns
      @insert_statement = InsertStatement.new(insert_statement_line)
    end

    def process
      return raw_line unless target_table?

      # TODO: define insert_statement.mask_values(column, mask_method) method & refactoring
      target_columns.columns(table_name: insert_statement.table).each do |target_column|
        insert_statement.values.map do |value|
          value[target_column.name] = target_column.method.call if value.has_column?(target_column.name)
        end
      end

      insert_statement.sql
    end

    def target_table?
      target_columns.contains?(table_name: insert_statement.table)
    end
  end
end
