module Rules
  class Trigger < Rule
    attr_accessor :callback

    def initialize model, options, block
      super
      @callback  = options[:on]
    end

    def execute! object
      return unless condition.true_for?(object)

      actions.each do |action|
        begin
          action.run_for!(object, name)
        rescue Exception => ex
          Triggerable::Engine.log(:error, "#{desc} failed with exception #{ex}")
        end
      end
    end
  end
end