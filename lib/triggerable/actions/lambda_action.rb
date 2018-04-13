module Triggerable
  module Actions
    class LambdaAction < Action
      def initialize(block)
        @block = block
      end

      def run_for!(object, trigger_name)
        proc = @block
        object.instance_eval do
          change_whodunnit = trigger_name.present? && defined?(PaperTrail)
          paper_trail = (defined?(PaperTrail::Request) ? PaperTrail.request : PaperTrail) if change_whodunnit
          old_whodunnit = nil

          if change_whodunnit
            old_whodunnit = paper_trail.whodunnit
            paper_trail.whodunnit = trigger_name
          end

          begin
            instance_exec(&proc)
          ensure
            paper_trail.whodunnit = old_whodunnit if change_whodunnit
          end
        end
      end
    end
  end
end
