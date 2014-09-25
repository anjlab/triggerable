module Conditions
  class IsNot < FieldCondition
    def true_for? object
      field_value(object) != @value
    end

    def comparator
      '<>'
    end
  end
end