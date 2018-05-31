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
      @raw_line             = insert_statement_line
      @target_columns       = target_columns
      @insert_statement = InsertStatement.new(insert_statement_line)
    end

    def process
      return raw_line unless target_table?
      ## code sample as for considering class design
      # # TODO: define InsertStatement.mask_value(column, mask_method) method
      # target_columns.each do |target_column, mask_method|
      #   insert_statement.values.map do |valus|
      #     value[target_column] = mask_method.call
      #   end
      # end
      #
      # insert_statement.sql
    end

    def target_table?
      target_columns.contains?(table: insert_statement.table)
    end
  end
end
