module Conditions
  class Or < PredicateCondition
    def true_for? object
      true_conditions(object).any?
    end
  end
end