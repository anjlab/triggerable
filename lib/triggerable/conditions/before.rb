module Conditions
  class Before < ScheduleCondition
    def scope
      from = (now + @value.hours).to_formatted_s(:db)
      to = (now + (@value + 1).hours).to_formatted_s(:db)
      { @field => from..to }
    end
  end
end