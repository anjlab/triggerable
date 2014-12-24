module Rules
  class Trigger < Rule
    attr_accessor :callback

    def initialize model, options, block
      super
      @callback  = options[:on]
    end

    def execute! object
      puts "#{desc}: #{condition.desc}" if debug?

      if condition.true_for?(object)
        actions.each do |a|
          begin
            a.run_for!(object, name)
          rescue Exception => ex
            "#{desc} failed with exception #{ex}"
          end
        end
      end
    end
  end
end