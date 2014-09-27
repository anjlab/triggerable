module Conditions
  class ScheduleCondition < FieldCondition
    def initialize field, value
      if value.is_a?(Hash)
        condition = value.keys.first
        value = value.values.first
      end

      super
    end

    def true_for? object
      condition.true_for?(object)
    end

    def scope
      condition.scope
    end

    protected
    # automation_time is Time.now rounded by Engine.interval
    def automation_time
      i = Engine.interval
      Time.at((Time.now.to_i / i) * i).utc
    end

    def condition
      And.new [
        GreaterThenOrEqualTo.new(@field, from),
        LessThen.new(@field, to)
      ]
    end
  end
end
