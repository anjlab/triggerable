module Conditions
  class In < FieldCondition
    def true_for? object
      @value.include?(field_value(object))
    end

    def comparator
      'IN'
    end

    private
    def sanitized_value
      "(#{super.join(',')})"
    end
  end
end