module Conditions
  class GreaterThen < FieldCondition
    def initialize field, condition
      super
      @ruby_comparator = @db_comparator = '>'
    end
  end
end