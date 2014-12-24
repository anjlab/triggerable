module Conditions
  class Or < PredicateCondition
    def true_for? object
      true_conditions(object).any?
    end

    def desc
      @conditions.map do |c|
        desc = c.try(:desc)
        desc ? "(#{desc})" : c
      end.join(' || ')
    end
  end
end