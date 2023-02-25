# frozen_string_literal: true

module Masking
  class InsertStatement
    class SQLBuilder
      def initialize(table:, columns:, values:)
        @table   = table
        @columns = columns
        @values  = values
      end

      def sql
        %(INSERT INTO `#{table}` #{columns_section} VALUES #{values_section};\n)
      end

      private

      attr_reader :table, :columns, :values

      def columns_section
        '(' + columns.map { |column| "`#{column}`" }.join(', ') + ')'
      end

      def values_section
        values.map { |value| "(#{value.join(',')})" }.join(',')
      end
    end
  end
end
