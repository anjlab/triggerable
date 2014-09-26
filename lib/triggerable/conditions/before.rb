module Conditions
  class Before < ScheduleCondition
    def from
      automation_time + @value
    end

    def to
      automation_time + @value + Engine.interval
    end
  end
end
