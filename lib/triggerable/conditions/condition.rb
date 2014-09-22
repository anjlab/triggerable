module Conditions
  class Condition
    def self.build condition
      return Condition.new if condition.blank?
      return LambdaCondition.new(condition) if condition.is_a?(Proc)

      key = condition.keys.first
      value = condition[key]

      if [:and, :or].include?(key)
        predicate_condition(key, value)
      else
        field_condition(key, value)
      end
    end

    def true_for?(object); true; end

    def scope; ''; end

    private

    def self.predicate_condition class_name, value
      condition_class(class_name).new(value)
    end

    def self.field_condition field, value
      if value.is_a?(Array)
        Conditions::In.new(field, value)
      elsif value.is_a?(Hash)
        condition_class(value.keys.first).new(field, value.values.first)
      else
        Conditions::Is.new(field, value)
      end
    end

    def self.condition_class sym
      "Conditions::#{sym.to_s.camelize}".constantize
    end
  end
end