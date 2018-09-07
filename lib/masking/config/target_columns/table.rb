# frozen_string_literal: true

require 'masking/config/target_columns/column'

module Masking
  class Config
    class TargetColumns
      class Table
        attr_reader :name, :columns

        def initialize(name, columns:)
          @name = name.to_sym
          @columns = columns.map do |column, method_value|
            Masking::Config::TargetColumns::Column.new(column, table_name: self.name, method_value: method_value)
          end
        end

        def ==(other)
          name == other.name
        end
      end
    end
  end
end
