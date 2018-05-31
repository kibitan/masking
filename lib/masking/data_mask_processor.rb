require "masking/config/target_columns"
require "masking/sql_insert_statement"

module Masking
  # TODO: find better naming/modeling of DataMaskProcessor
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
      ## code sample as for considering class design
      # # TODO: define SQLInsertStatement.mask_value(column, mask_method) method
      # target_columns.each do |target_column, mask_method|
      #   sql_insert_statement.values.map do |valus|
      #     value[target_column] = mask_method.call
      #   end
      # end
      #
      # sql_insert_statement.sql
    end

    def target_table?
      target_columns.contains?(table: sql_insert_statement.table)
    end
  end
end
