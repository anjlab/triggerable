module Triggerable
  module Rules
    class Automation < Rule
      attr_accessor :pass_relation

      def initialize model, options, block
        super(model, options, block)
        @pass_relation = options[:pass_relation]
        @unscoped = options[:unscoped]
      end

      def execute!
        ids = ActiveRecord::Base.connection.execute(build_query).map { |r| r['id'] }
        models = @unscoped ? model.unscoped : model
        models = models.where(id: ids)

        Triggerable::Engine.log(:debug, "#{desc}: processing #{models.count} object(s)")

        if @pass_relation
          execute_on!(models)
        else
          models.each { |object| execute_on!(object) }
        end
      end

      private

      def build_query
        table = Arel::Table.new(model.table_name)
        query = table.where(@condition.scope(table))
                     .project(Arel.sql('id'))
                     .to_sql

        Triggerable::Engine.log(:debug, "#{desc}: #{query}")

        query
      end

      def execute_on!(target)
        begin
          actions.each {|a| a.run_for!(target, name)}
        rescue Exception => ex
          Triggerable::Engine.log(:error, "#{desc} failed with exception #{ex}")
        end
      end
    end
  end
end
