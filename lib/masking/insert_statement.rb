# frozen_string_literal: true

require 'masking/insert_statement/sql_builder'

module Masking
  class InsertStatement
    include Enumerable

    attr_reader :raw_statement, :table, :table_columns
    VALUES_LITERAL = ") VALUES ("

    def initialize(raw_statement, table_columns)
      @raw_statement = raw_statement
      @table_columns = table_columns
      @value_start_index = @raw_statement.index(VALUES_LITERAL) + VALUES_LITERAL.size - 2
      @value_end_index = @raw_statement.size - 3

      PARSE_REGEXP.match(raw_statement).tap do |match_data|
        @table           = match_data[:table]
        @columns_section = match_data[:columns_section]
      end
    end

    def values_separators
      @values_separater ||= value_separate_commas
    end

    def columns
      # NOTE: define and extract to ColumnSet class?
      @columns ||= columns_section.scan(COLUMNS_REGEXP).flatten.map(&:to_sym)
    end

    # only for spec
    def values
      results = []
      iterate do |vals|
        results << vals
      end
      results
    end

    def each
      iterate { |vals| yield anonymize_values(vals) }
    end

    def sql
      SQLBuilder.build(table: table, columns: columns, values: self)
    end

    private

    attr_reader :raw_statement, :value_start_index, :value_end_index

    def iterate
      values_separators.each do |indices|
        vals = []
        start_index = indices.first
        indices[1..-1].each do |index|
          vals << raw_statement[start_index+1..index-1]
          start_index = index
        end

        yield vals
      end
    end

    def anonymize_values(values)
      columns_to_anonymize = table_columns.columns(table_name: table)
      if columns_to_anonymize.first.index.nil?
        columns_to_anonymize.each do |target_column|
          target_column.index = columns.index(target_column.name)
        end
      end

      columns_to_anonymize.each do |target_column|
        values[target_column.index] = target_column.masked_value unless target_column.index.nil?
      end
      values
    end

    def value_separate_commas
      p_open = false
      q_open = false
      comma_indexes = []
      value_sep = []

      index = value_start_index
      while index < value_end_index
        case raw_statement[index+=1]
        when '('
          next if q_open
          value_sep << index
          p_open = true
        when '\\'
          nchar = raw_statement[index+1]
          if raw_statement[index+1] == ?' || nchar == ?\\
            index += 1
          end
        when ?'
          q_open = !q_open
        when ','
          if p_open
            next if q_open
            value_sep << index
          end
        when ')'
          unless q_open
            value_sep << index
            comma_indexes << value_sep
            value_sep = []
            p_open = false
          end
        end
      end

      comma_indexes
    end

    attr_reader :columns_section, :values_section

    PARSE_REGEXP = /INSERT INTO `(?<table>.+)` \((?<columns_section>.+)\)/.freeze
    COLUMNS_REGEXP = /`(.*?)`/.freeze
  end
end
