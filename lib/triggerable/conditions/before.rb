module Conditions
  class Before < ScheduleCondition
    def scope
      from = (now + @value).to_formatted_s(:db)
      to = (now + @value + Engine.interval).to_formatted_s(:db)
      { @field => from..to }
    end
  end
end