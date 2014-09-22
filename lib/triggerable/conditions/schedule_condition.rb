module Conditions
  class ScheduleCondition
    def initialize date, hours
      @date = date
      @hours = hours
    end

    protected
    def now
      Time.now.beginning_of_hour
    end
  end
end