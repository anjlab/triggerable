module Conditions
  class After < ScheduleCondition
    def from
      case @math_condition
      when :greater_than, :less_than
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
      when :greater_than
        LessThanOrEqualTo.new(@field, from)
      when :less_than
        GreaterThanOrEqualTo.new(@field, from)
      end
    end
  end
end
