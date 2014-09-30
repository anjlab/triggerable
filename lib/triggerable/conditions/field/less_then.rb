module Conditions
  class LessThen < FieldCondition
    def initialize field, condition
      super
      @ruby_comparator = @db_comparator = '<'
    end
  end
end