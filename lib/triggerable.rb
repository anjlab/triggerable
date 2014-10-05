require "triggerable/version"

require "triggerable/engine"

require "triggerable/rules/rule"
require "triggerable/rules/trigger"
require "triggerable/rules/automation"

require "triggerable/conditions/condition"
require "triggerable/conditions/lambda_condition"
require "triggerable/conditions/method_condition"

require "triggerable/conditions/field/field_condition"
require "triggerable/conditions/field/exists"
require "triggerable/conditions/field/in"
require "triggerable/conditions/field/or_equal_to"

require "triggerable/conditions/predicate/predicate_condition"
require "triggerable/conditions/predicate/and"
require "triggerable/conditions/predicate/or"

require "triggerable/conditions/schedule/schedule_condition"
require "triggerable/conditions/schedule/before"
require "triggerable/conditions/schedule/after"

require "triggerable/actions"

module Triggerable
  extend ActiveSupport::Concern

  included do
    CALLBACKS = [:before_create, :before_save, :before_update, :after_create, :after_save, :after_update]
    CALLBACKS.each do |callback|
      method_name = "run_#{callback}_triggers"
      define_method(method_name) { run_triggers(callback) }
      send(callback, method_name)
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

COMPARSIONS = [
  { name: 'Is',          ancestor: Conditions::FieldCondition, args: { ruby_comparator: '==', db_comparator: 'eq' }  },
  { name: 'GreaterThen', ancestor: Conditions::FieldCondition, args: { ruby_comparator: '>',  db_comparator: 'gt' }  },
  { name: 'LessThen',    ancestor: Conditions::FieldCondition, args: { ruby_comparator: '<',  db_comparator: 'lt' }  },
  { name: 'IsNot',       ancestor: Conditions::FieldCondition, args: { ruby_comparator: '!=', db_comparator: 'not_eq'}  },

  { name: 'GreaterThenOrEqualTo', ancestor: Conditions::OrEqualTo, args: { db_comparator: 'gteq', additional_condition: 'Conditions::GreaterThen' } },
  { name: 'LessThenOrEqualTo',    ancestor: Conditions::OrEqualTo, args: { db_comparator: 'lteq', additional_condition: 'Conditions::LessThen'    } }
]

COMPARSIONS.each do |desc|
  klass = Class.new(desc[:ancestor]) do
    define_method :initialize do |field, value|
      desc[:args].each_pair { |name, val| instance_variable_set("@#{name}".to_sym, val) }
      super(field, value)
    end
  end

  Conditions.const_set(desc[:name], klass)
end

ActiveSupport.on_load(:active_record) { include Triggerable }
