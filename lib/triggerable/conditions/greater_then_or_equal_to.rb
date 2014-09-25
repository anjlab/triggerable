module Conditions
  class GreaterThenOrEqualTo < CompositeCondition
    def scope
      "#{@field} >= #{sanitized_value}"
    end

    protected
    def build_condition field, value
      Or.new [
        GreaterThen.new(field, value),
        Is.new(field, value)
      ]
    end
  end
end