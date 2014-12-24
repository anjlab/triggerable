module Conditions
  class In < FieldCondition
    def initialize field, condition
      super
      @db_comparator = 'in'
    end

    def true_for? object
      @value.include?(field_value(object))
    end

    def desc
      "#{@field} #{@db_comparator} #{@value}"
    end

    private
    def sanitized_value
      "(#{super.join(',')})"
    end
  end
end