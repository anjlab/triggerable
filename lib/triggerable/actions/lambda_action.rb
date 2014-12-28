module Triggerable
  module Actions
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
end