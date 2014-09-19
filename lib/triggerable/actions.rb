class Action
  def self.build source
    if source.is_a?(Proc)
      [LambdaAction.new(source)]
    else
      Array(source).map {|s| s.to_s.camelize.constantize.new }
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