module Conditions
  class After < ScheduleCondition
    def from
      build_time(Engine.interval)
    end

    def to
      build_time
    end

    private
    def build_time add = nil
      date = now - @value
      if add.present?
        date -= add
      end
      format(date)
    end
  end
end