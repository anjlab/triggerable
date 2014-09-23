module Conditions
  class ScheduleCondition < FieldCondition
    protected
    def now
      Time.now.beginning_of_hour
    end
  end
end