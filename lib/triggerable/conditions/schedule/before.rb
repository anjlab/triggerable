module Conditions
  class Before < ScheduleCondition
    def from
      case @math_condition
      when :greater_then
        Time.now
      when :less_then
        Time.now + @value
      when nil
        automation_time + @value
      end
    end

    def to
      case @math_condition
      when :greater_then
        Time.now + @value
      when nil
        automation_time + @value + Engine.interval
      end
    end

    private
    def condition
      return super if @math_condition.blank?

      case @math_condition
      when :greater_then
        And.new([GreaterThenOrEqualTo.new(@field, from), LessThen.new(@field, to)])
      when :less_then
        GreaterThenOrEqualTo.new(@field, from)
      end
    end
  end
end
