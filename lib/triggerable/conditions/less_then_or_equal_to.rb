module Conditions
  class LessThenOrEqualTo < CompositeCondition
    def scope
      "#{@field} <= #{sanitized_value}"
    end

    protected
    def build_condition field, value
      Or.new [
        LessThen.new(field, value),
        Is.new(field, value)
      ]
    end
  end
end