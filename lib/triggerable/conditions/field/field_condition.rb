module Conditions
  class FieldCondition < Condition
    def initialize field, value
      @field = field
      @value = value
    end

    def scope
      "#{@field} #{comparator} #{sanitized_value}"
    end

    protected
    def field_value object
      object.send(@field)
    end

    def sanitized_value
      if @value.is_a?(Array)
        @value.map{|v| ActiveRecord::Base::sanitize(v)}
      else
        ActiveRecord::Base::sanitize(@value)
      end
    end
  end
end