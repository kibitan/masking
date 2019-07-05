# frozen_string_literal: true

require 'masking/insert_statement/sql_builder'

module Masking
  class InsertStatement
    attr_reader :raw_statement, :table

    def initialize(raw_statement)
      @raw_statement = raw_statement

      PARSE_REGEXP.match(raw_statement).tap do |match_data|
        @table           = match_data[:table]
        @columns_section = match_data[:columns_section]
        @values_section  = match_data[:values_section]
      end
    end

    def values_separators
      @values_separater ||= value_separate_commas
    end

    def columns
      # NOTE: define and extract to ColumnSet class?
      @columns ||= columns_section.scan(COLUMNS_REGEXP).flatten.map(&:to_sym)
    end

    def values
      @values = []
      values_separators.each do |indices|
        vals = []
        start_index = indices.first
        indices[1..-1].each do |index|
          vals << raw_statement[start_index+1..index-1]
          start_index = index
        end
        @values << vals
      end
      @values
    end

    def sql
      SQLBuilder.build(table: table, columns: columns, values: values)
    end

    private

    attr_reader :raw_statement, :value_start_index, :value_end_index

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

    VALUE_ROW_SPLITTER = '),('
    PARSE_REGEXP = /INSERT INTO `(?<table>.+)` \((?<columns_section>.+)\) VALUES (?<values_section>.+);/.freeze
    COLUMNS_REGEXP = /`(.*?)`/.freeze
  end
end
