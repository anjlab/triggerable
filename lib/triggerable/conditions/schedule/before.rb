module Conditions
  class Before < ScheduleCondition
    def from
      case @math_condition
      when :greater_than
        Time.now
      when :less_than
        Time.now + @value
      when nil
        automation_time + @value
      end
    end

    def to
      case @math_condition
      when :greater_than
        Time.now + @value
      when nil
        automation_time + @value + Engine.interval
      end
    end

    private
    def condition
      if @math_condition.blank?
        And.new [
          GreaterThanOrEqualTo.new(@field, from),
          LessThan.new(@field, to)
        ]
      else
        case @math_condition
        when :greater_than
          And.new([GreaterThanOrEqualTo.new(@field, from), LessThan.new(@field, to)])
        when :less_than
          GreaterThanOrEqualTo.new(@field, from)
        end
      end
    end
  end
end
