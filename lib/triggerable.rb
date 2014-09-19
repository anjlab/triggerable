require "triggerable/version"

require "triggerable/engine"

require "triggerable/rules/rule"
require "triggerable/rules/trigger"
require "triggerable/rules/automation"

require "triggerable/schedulers/scheduler"
require "triggerable/schedulers/before"
require "triggerable/schedulers/after"

require "triggerable/conditions/condition"
require "triggerable/conditions/field_condition"
require "triggerable/conditions/predicate_condition"
require "triggerable/conditions/lambda_condition"
require "triggerable/conditions/and"
require "triggerable/conditions/or"
require "triggerable/conditions/exists"
require "triggerable/conditions/greater_then"
require "triggerable/conditions/less_then"
require "triggerable/conditions/in"
require "triggerable/conditions/is"
require "triggerable/conditions/is_not"

require "triggerable/actions"

module Triggerable
  extend ActiveSupport::Concern

  included do
    CALLBACKS = [:create, :save, :update]
    CALLBACKS.each do |callback|
      ar_callback = "after_#{callback}".to_sym
      method_name = "run_#{ar_callback}_triggers"
      define_method(method_name) { run_triggers(callback) }
      send(ar_callback, method_name)
    end

    private

    def run_triggers callback
      Engine.triggers_for(self.class, callback).each{|t| t.execute!(self)}
    end
  end

  module ClassMethods
    def trigger options, &block
      Engine.trigger(self, options, block)
    end

    def automation options, &block
      Engine.automation(self, options, block)
    end
  end
end
