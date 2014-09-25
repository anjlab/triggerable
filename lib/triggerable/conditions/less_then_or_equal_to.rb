module Conditions
  class LessThenOrEqualTo < OrEqualTo
    protected
    def additional_condition
      LessThen
    end

    def comparsion_operator
      '<'
    end
  end
end