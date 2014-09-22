module Conditions
  class Before < ScheduleCondition
    def scope
      from = (now + @hours.hours).to_formatted_s(:db)
      to = (now + (@hours + 1).hours).to_formatted_s(:db)
      { @date => from..to }
    end
  end
end