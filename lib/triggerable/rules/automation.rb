module Triggerable
  module Rules
    class Automation < Rule
      def execute!
        ids = ActiveRecord::Base.connection.execute(build_query).map { |r| r['id'] }
        models = model.where(id: ids)

        Triggerable::Engine.log(:debug, "#{desc}: processing #{models.count} object(s)")

        models.each do |object|
          begin
            actions.each {|a| a.run_for!(object, name)}
          rescue Exception => ex
            Triggerable::Engine.log(:error, "#{desc} failed with exception #{ex}")
          end
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
    end
  end
end