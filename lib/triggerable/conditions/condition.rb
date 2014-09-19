module Conditions
  class Condition
    def self.build condition
      return Condition.new if condition.blank?
      return LambdaCondition.new(condition) if condition.is_a?(Proc)

      key = condition.keys.first
      value = condition[key]

      case key
      when :and, :or
        condition_class(key).new(value)
      else
        if value.is_a?(Array)
          Conditions::In.new(key, value)
        elsif !value.is_a?(Hash)
          Conditions::Is.new(key, value)
        else
          condition_klass = condition_class(value.keys.first)
          condition_klass.new(key, value.values.first)
        end
      end
    end

    def true_for?(object); true; end

    def scope; ''; end

    private

    def self.condition_class sym
      "Conditions::#{sym.to_s.camelize}".constantize
    end
  end
end