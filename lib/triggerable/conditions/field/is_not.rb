module Conditions
  class IsNot < FieldCondition
    def initialize field, condition
      super
      @ruby_comparator = '!='
      @db_comparator   = '<>'
    end
  end
end