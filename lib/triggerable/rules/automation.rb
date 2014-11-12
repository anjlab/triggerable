module Rules
  class Automation < Rule
    def execute!
      table = Arel::Table.new(model.table_name)
      scope = @condition.scope(table)
      query = table.where(scope).project(Arel.sql('id')).to_sql
      ids = ActiveRecord::Base.connection.execute(query).map { |r| r['id'] }
      models = model.where(id: ids)

      models.each {|object| actions.each {|a| a.run_for!(object, name)} }
    end
  end
end
