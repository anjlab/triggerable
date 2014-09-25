module Conditions
  class CompositeCondition < FieldCondition
    def initialize field, value
      super
      @condition = build_condition(field, value)
    end

    def true_for? object
      @condition.true_for?(object)
    end
  end
end