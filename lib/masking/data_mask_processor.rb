require "masking/config/target_columns"
require "masking/sql_insert_statement"

module Masking
  class DataMaskProcessor
    class << self
      def process(sql_insert_statement_line, target_columns: Config::TargetColumns.new)
        new(sql_insert_statement_line, target_columns: target_columns).send(:process)
      end
    end

    private

    attr_reader :raw_line, :target_columns, :sql_insert_statement

    def initialize(sql_insert_statement_line, target_columns:)
      @raw_line             = sql_insert_statement_line
      @target_columns       = target_columns
      @sql_insert_statement = SQLInsertStatement.new(sql_insert_statement_line)
    end

    def process
      return raw_line unless target_table?
    end

    def target_table?
      target_columns.contains?(table_name: sql_insert_statement.table_name)
    end
  end
end
