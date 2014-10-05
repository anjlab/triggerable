module Conditions
  class After < ScheduleCondition
    def from
      case @math_condition
      when :greater_then, :less_then
        Time.now - @value
      when nil
        automation_time - @value - Engine.interval
      end
    end

    def to
      automation_time - @value
    end

    private
    def condition
      return super if @math_condition.blank?

      case @math_condition
      when :greater_then
        LessThenOrEqualTo.new(@field, from)
      when :less_then
        GreaterThenOrEqualTo.new(@field, from)
      end
    end
  end
end
