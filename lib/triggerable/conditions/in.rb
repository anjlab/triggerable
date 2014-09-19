module Conditions
  class In < FieldCondition
    def true_for? object
      @value.include?(field_value(object))
    end

    def scope
      "#{@field} IN (#{sanitized_value.join(',')})"
    end
  end
end