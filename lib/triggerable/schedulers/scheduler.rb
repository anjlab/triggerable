module Schedulers
  class Scheduler
    def self.build kind, options
      "Schedulers::#{kind.to_s.camelize}".constantize.new(options)
    end

    def initialize options
      @date = "#{options.keys.first}d_at"
      @hours = options.values.first
    end

    protected
    def now
      Time.now.beginning_of_hour
    end
  end
end