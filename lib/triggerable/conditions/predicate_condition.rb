module Conditions
  class PredicateCondition < Condition
    attr_accessor :conditions

    def initialize statements
      @conditions = statements.map do |hash|
        field = hash.keys.first
        statement = hash.values.first
        Condition.build({field => statement})
      end
    end

    def scope
      @conditions.map(&:scope).join(" #{self.class.name.demodulize.upcase} ")
    end

    protected

    def true_conditions object
      @conditions.select {|c| c.true_for?(object) }
    end
  end
end