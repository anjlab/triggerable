require 'logger'

module Triggerable
  class Engine
    cattr_accessor :triggers,
                   :automations,
                   :interval,
                   :logger,
                   :debug

    self.triggers    = []
    self.automations = []

    def self.trigger model, options, block
      self.triggers << Rules::Trigger.new(model, options, block)
    end

    def self.automation model, options, block
      self.automations << Rules::Automation.new(model, options, block)
    end

    def self.triggers_for obj, callback
      triggers.select { |t| obj.class.name == t.model.name && t.callback == callback }
    end

    def self.run_automations interval
      self.interval = interval
      return unless Triggerable.enabled?
      automations.each(&:execute!)
    end

    def self.clear
      self.triggers    = []
      self.automations = []
    end

    def self.log level, message
      puts message if debug
      logger.send(level, "#{Time.now.strftime('%FT%T%z')}: #{message}") if logger.present?
    end
  end
end