module Schedulers
  class After < Scheduler
    def scope
      from = (now - (@hours + 1).hours).to_formatted_s(:db)
      to = (now - @hours.hours).to_formatted_s(:db)
      { @date => from..to }
    end
  end
end