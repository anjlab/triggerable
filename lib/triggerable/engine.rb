class Engine
  cattr_accessor :triggers, :automations, :interval

  self.triggers = []
  self.automations = []

  def self.trigger model, options, block
    self.triggers << Rules::Trigger.new(model, options, block)
  end

  def self.automation model, options, block
    self.automations << Rules::Automation.new(model, options, block)
  end

  def self.triggers_for model, callback
    triggers.select{|t| t.model == model && t.callback == callback }
  end

  def self.run_automations interval
    self.interval = interval
    automations.each(&:execute!)
  end

  def self.clear
    self.triggers = []
    self.automations = []
  end
end