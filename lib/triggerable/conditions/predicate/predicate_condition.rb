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

    def scope
      @conditions.map(&:scope).join(" #{self.class.name.demodulize.upcase} ")
    end

    protected

    def true_conditions object
      @conditions.select {|c| c.true_for?(object) }
    end
  end
end