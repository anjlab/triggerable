module Conditions
  class GreaterThenOrEqualTo < OrEqualTo
    def initialize field, condition
      @db_comparator = '>='
      @additional_condition = GreaterThen
      super
    end
  end
end