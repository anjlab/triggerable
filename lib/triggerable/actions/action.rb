module Triggerable
  module Actions
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

      def run_for!(trigger_name, object); end
    end
  end
end