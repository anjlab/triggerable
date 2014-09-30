module Conditions
  class LessThenOrEqualTo < OrEqualTo
    def initialize field, condition
      @db_comparator        = '<='
      @additional_condition = LessThen
      super
    end
  end
end