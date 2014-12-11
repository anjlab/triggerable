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

    def run_for!(trigger_name, object); end
  end

  class LambdaAction < Action
    def initialize block
      @block = block
    end

    def run_for! object, trigger_name
      proc = @block
      object.instance_eval do
        change_whodunnit = trigger_name.present? && defined?(PaperTrail)
        old_whodunnit = nil

        if change_whodunnit
          old_whodunnit = PaperTrail.whodunnit
          PaperTrail.whodunnit = trigger_name
        end

        begin
          instance_exec(&proc)
        ensure
          PaperTrail.whodunnit = old_whodunnit if change_whodunnit
        end
      end
    end
  end
end