module Masking
  class InsertStatement
    class Builder
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
        %Q|INSERT INTO `#{table}` #{columns_section} VALUES #{values_section};|
      end

      def columns_section
        '(' + columns.map { |column| "`#{column}`" }.join(', ') + ')'
      end

      def values_section
        values.map(&:phrase).join(?,)
      end
    end
  end
end
