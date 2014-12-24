module Conditions
  class ScheduleCondition < FieldCondition
    def initialize field, value
      @value = value.values.first if value.is_a?(Hash)
      super
    end

    def true_for? object
      condition.true_for?(object)
    end

    def scope table
      condition.scope(table)
    end

    protected

    # automation_time is Time.now rounded by Engine.interval
    def automation_time
      i = Triggerable::Engine.interval
      Time.at((Time.now.to_i / i) * i).utc
    end
  end
end
