module Conditions
  class PredicateCondition < Condition
    attr_accessor :conditions

    def initialize conditions
      @conditions = conditions.map do |condition|
        unless condition.is_a?(Hash)
          condition
        else
          field     = condition.keys.first
          statement = condition.values.first

          Condition.build({field => statement})
        end
      end
    end

    def scope table
      predicate_scope = nil

      @conditions.each_with_index do |condition, index|
        condition_scope = condition.scope(table)

        predicate_scope = if index.zero?
          condition_scope
        else
          predicate_scope.send(predicate_name, condition_scope)
        end
      end

      predicate_scope
    end

    protected

    def predicate_name
      self.class.name.demodulize.downcase
    end

    def true_conditions object
      @conditions.select do |c|
        c.is_a?(Symbol) ? object.send(c) : c.true_for?(object)
      end
    end
  end
end