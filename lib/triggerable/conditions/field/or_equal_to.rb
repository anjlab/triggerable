module Triggerable
  module Conditions
    class OrEqualTo < FieldCondition
      def initialize field, value
        super
        @condition = Or.new [
          @additional_condition.constantize.new(field, value),
          Is.new(field, value)
        ]
      end

      def true_for? object
        @condition.true_for?(object)
      end
    end
  end
end