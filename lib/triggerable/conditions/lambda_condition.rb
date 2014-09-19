module Conditions
  class LambdaCondition < Condition
    def initialize block
      @block = block
    end

    def true_for? object
      @block.(object)
    end
  end
end