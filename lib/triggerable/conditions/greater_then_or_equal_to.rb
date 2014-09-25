module Conditions
  class GreaterThenOrEqualTo < OrEqualTo
    protected
    def additional_condition
      GreaterThen
    end

    def comparsion_operator
      '>'
    end
  end
end