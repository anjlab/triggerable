module Conditions
  class After < ScheduleCondition
    def scope
      from = (now - (@value + 1).hours).to_formatted_s(:db)
      to = (now - @value.hours).to_formatted_s(:db)
      { @field => from..to }
    end
  end
end