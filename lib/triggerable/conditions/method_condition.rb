module Conditions
  class MethodCondition < Condition
    def initialize method_name
      @method_name = method_name
    end

    def true_for? object
      object.send(@method_name)
    end
  end
end