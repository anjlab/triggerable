module Triggerable
  module Conditions
    class After < ScheduleCondition
      def from
        automation_time - @value - Triggerable::Engine.interval
      end

      def to
        automation_time - @value
      end

      private

      def condition
        And.new [
          GreaterThan.new(@field, from),
          LessThanOrEqualTo.new(@field, to)
        ]
      end
    end
  end
end