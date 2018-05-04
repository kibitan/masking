module Masking
  class SQLDataStatement::Value < SimpleDelegator
    def initialize(columns:, data:)
      @data = Struct.new(*columns).new(*data)
      super(@data)
    end

    def statement
      to_a.join(?,)
    end
  end
end
