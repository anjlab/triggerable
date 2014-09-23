module Conditions
  class ScheduleCondition < FieldCondition
    def true_for? object
      condition.true_for?(object)
    end

    def scope
      condition.scope
    end

    protected
    def now
      Time.now.beginning_of_hour
    end

    def format date
      date.to_formatted_s(:db)
    end

    def condition
      And.new [
        GreaterThenOrEqualTo.new(@field, from),
        LessThen.new(@field, to)
      ]
    end
  end
end