module Rules
  class Trigger < Rule
    attr_accessor :callback

    def initialize model, options, block
      super
      @callback  = options[:on]
    end

    def execute! object
      actions.each {|a| a.run_for!(object)} if condition.true_for?(object)
    end
  end
end