module Conditions
  class And < PredicateCondition
    def true_for? object
      true_conditions(object).count == @conditions.count
    end

    def desc
      @conditions.map { |c| c.try(:desc) || c }.join(' && ')
    end
  end
end