module Conditions
  class Before < ScheduleCondition
    def from
      automation_time + @value
    end

    def to
      automation_time + @value + Engine.interval
    end

    private

    def condition
      And.new [
        GreaterThanOrEqualTo.new(@field, from),
        LessThan.new(@field, to)
      ]
    end
  end
end
