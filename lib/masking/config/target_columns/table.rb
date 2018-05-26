require 'masking/config/target_columns/column'

module Masking
  module Config
    class TargetColumns
      class Table
        attr_reader :name, :columns

        def initialize(name, columns:)
          @name = name.to_sym
          @columns = columns.map { |column| Masking::Config::TargetColumns::Column.new(column) }
        end
      end
    end
  end
end
