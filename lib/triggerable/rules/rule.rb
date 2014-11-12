module Rules
  class Rule
    attr_accessor :name, :model, :condition, :actions

    def initialize model, options, block
      @model     = model
      @condition = Conditions::Condition.build(options[:if])
      @name      = options[:name]
      @actions   = Triggerable::Action.build(block || options[:do])
    end
  end
end