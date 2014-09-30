module Conditions
  class FieldCondition < Condition
    def initialize field, value
      @field = field
      @value = value
    end

    def true_for? object
      field_value(object).send(@ruby_comparator, @value)
    end

    def scope
      "#{@field} #{@db_comparator} #{sanitized_value}"
    end

    private
    def field_value object
      object.send(@field)
    end

    def sanitized_value
      if @value.is_a?(Array)
        @value.map { |v| ActiveRecord::Base::sanitize(v) }
      else
        ActiveRecord::Base::sanitize(@value)
      end
    end
  end

  SIMPLE_CONDITIONS = [
    { name: 'Is',          ruby_comparator: '==', db_comparator: '='  },
    { name: 'GreaterThen', ruby_comparator: '>',  db_comparator: '>'  },
    { name: 'LessThen',    ruby_comparator: '<',  db_comparator: '<'  },
    { name: 'IsNot',       ruby_comparator: '!=', db_comparator: '<>' }
  ]

  SIMPLE_CONDITIONS.each do |desc|
    klass = Class.new(FieldCondition) do
      define_method :initialize do |field, value|
        @ruby_comparator = desc[:ruby_comparator]
        @db_comparator   = desc[:db_comparator]
        super(field, value)
      end
    end

    Conditions.const_set(desc[:name], klass)
  end
end