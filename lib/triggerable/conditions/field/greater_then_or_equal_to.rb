module Conditions
  class GreaterThenOrEqualTo < OrEqualTo
    protected
    def additional_condition
      GreaterThen
    end

    def comparator
      '>='
    end
  end
end