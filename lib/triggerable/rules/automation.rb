module Rules
  class Automation < Rule
    def initialize model, options, block
      super
      schedule = options.keys.find {|k| [:before, :after].include?(k) }
      @scheduler = Schedulers::Scheduler.build(schedule, options[schedule])
    end

    def execute!
      models = model.where(@scheduler.scope).where(@condition.scope)
      models.each {|o| actions.each {|a| a.run_for!(o)} }
    end
  end
end