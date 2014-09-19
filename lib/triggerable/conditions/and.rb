module Conditions
  class And < PredicateCondition
    def true_for? object
      true_conditions(object).count == @conditions.count
    end
  end
end