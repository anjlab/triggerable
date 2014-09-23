module Conditions
  class GreaterThenOrEqualTo < FieldCondition
    def initialize field, value
      super
      @condition = Or.new [
        GreaterThen.new(field, value),
        Is.new(field, value)
      ]
    end

    def true_for? object
      @condition.true_for?(object)
    end

    def scope
      "#{@field} >= #{sanitized_value}"
    end
  end
end