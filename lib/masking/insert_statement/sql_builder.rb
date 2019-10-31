# frozen_string_literal: true

module Masking
  class InsertStatement
    class SQLBuilder
      class << self
        def build(table:, columns:, values:)
          new(table: table, columns: columns, values: values).send(:build)
        end
      end

      private

      attr_reader :table, :columns, :values
      def initialize(table:, columns:, values:)
        @table   = table
        @columns = columns
        @values  = values
      end

      def build
        %(INSERT INTO `#{table}` #{columns_section} VALUES #{values_section};\n)
      end

      def columns_section
        '(' + columns.map { |column| "`#{column}`" }.join(', ') + ')'
      end

      def values_section
        values.map { |value| '(' + value.join(',') + ')' }.join(',')
      end
    end
  end
end
