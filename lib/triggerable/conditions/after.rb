module Conditions
  class After < ScheduleCondition
    def scope
      from = (now - @value - Engine.interval).to_formatted_s(:db)
      to = (now - @value).to_formatted_s(:db)
      { @field => from..to }
    end
  end
end