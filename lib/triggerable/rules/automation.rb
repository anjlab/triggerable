module Rules
  class Automation < Rule
    def execute!
      models = model.where(@condition.scope)
      models.each {|o| actions.each {|a| a.run_for!(o)} }
    end
  end
end
