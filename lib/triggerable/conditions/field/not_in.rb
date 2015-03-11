module Triggerable
  module Conditions
    class NotIn < FieldCondition
      def initialize field, condition
        super
        @db_comparator = 'not in'
      end

      def true_for? object
        !@value.include?(field_value(object))
      end

      def desc
        "#{@field} #{@db_comparator} #{@value}"
      end

      def scope table
        Arel::Nodes::SqlLiteral.new("#{@field} #{@db_comparator} #{sanitized_value}")
      end

      private
      def sanitized_value
        "(#{super.join(',')})"
      end
    end
  end
end