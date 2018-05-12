module Masking
  class SQLInsertStatement::Value < SimpleDelegator
    def initialize(columns:, data:)
      @data = Struct.new(*columns).new(*data)
      super(@data)
    end

    def phrase
      '(' + to_a.join(?,) + ')'
    end

    # override for make comparable
    # NOTE: original #== method comapares struct subclass
    def ==(other)
      to_h == other.to_h
    end
  end
end
