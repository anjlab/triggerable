module Triggerable
  class Action
    def self.build source
      if source.is_a?(Proc)
        [LambdaAction.new(source)]
      else
        Array(source).map do |source|
          descendant = descendants.find { |d| d == source.to_s.camelize.constantize }
          descendant.new if descendant.present?
        end.compact
      end
    end

    def run_for!(object); end
  end

  class LambdaAction < Action
    def initialize block
      @block = block
    end

    def run_for! object
      @block.(object)
    end
  end
end