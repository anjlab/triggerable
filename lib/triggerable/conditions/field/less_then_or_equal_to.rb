module Conditions
  class LessThenOrEqualTo < OrEqualTo
    protected
    def additional_condition
      LessThen
    end

    def comparator
      '<='
    end
  end
end