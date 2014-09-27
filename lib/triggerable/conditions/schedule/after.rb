module Conditions
  class After < ScheduleCondition
    def from
      automation_time - @value - Engine.interval
    end

    def to
      automation_time - @value
    end
  end
end
