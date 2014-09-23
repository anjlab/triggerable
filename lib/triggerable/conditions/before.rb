module Conditions
  class Before < ScheduleCondition
    def from
      build_time
    end

    def to
      build_time(Engine.interval)
    end

    private
    def build_time add = nil
      format([now, @value, add].compact.sum)
    end
  end
end