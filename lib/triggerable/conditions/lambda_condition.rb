module Conditions
  class LambdaCondition < Condition
    def initialize block
      @block = block
    end

    def true_for? object
      proc = @block
      object.instance_eval { instance_exec(&proc) }
    end
  end
end