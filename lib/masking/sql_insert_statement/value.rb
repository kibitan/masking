module Masking
  class SQLInsertStatement::Value < SimpleDelegator
    def initialize(columns:, data:)
      @data = Struct.new(*columns).new(*data)
      super(@data)
    end

    def phrase
      '(' + to_a.join(?,) + ')'
    end
  end
end
