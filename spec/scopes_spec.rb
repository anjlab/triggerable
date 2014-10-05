require 'spec_helper'

describe 'Scopes' do
  before :each do
    ParentModel.destroy_all

    @m1 = ParentModel.create(integer_field: 1, string_field: 'a')
    @m2 = ParentModel.create(integer_field: 2, string_field: 'b')
    @m3 = ParentModel.create(integer_field: 1, string_field: 'c')
  end

  context 'field conditions' do
    def model_ids_for condition_class, arg
      table = Arel::Table.new(:parent_models)
      scope = condition_class.new(:integer_field, arg).scope(table)
      query = table.where(scope).project(Arel.sql('id')).to_sql

      ParentModel.connection.execute(query).map { |r| r['id'] }
    end

    it 'is' do
      ids = model_ids_for(Conditions::Is, 1)
      expect(ids).to eq([@m1.id, @m3.id])
    end

    it 'greater then' do
      ids = model_ids_for(Conditions::GreaterThen, 1)
      expect(ids).to eq([@m2.id])
    end

    it 'less then' do
      ids = model_ids_for(Conditions::LessThen, 2)
      expect(ids).to eq([@m1.id, @m3.id])
    end

    it 'is not' do
      ids = model_ids_for(Conditions::IsNot, 2)
      expect(ids).to eq([@m1.id, @m3.id])
    end

    it 'greater then or equal' do
      ids = model_ids_for(Conditions::LessThenOrEqualTo, 2)
      expect(ids).to eq([@m1.id, @m2.id, @m3.id])
    end

    it 'less then or equal' do
      ids = model_ids_for(Conditions::GreaterThenOrEqualTo, 1)
      expect(ids).to eq([@m1.id, @m2.id, @m3.id])
    end

    it 'in' do
      ids = model_ids_for(Conditions::In, [1, 2])
      expect(ids).to eq([@m1.id, @m2.id, @m3.id])
    end
  end

  context 'predicates' do
    it 'and' do
      and_condition = Conditions::And.new([])
      and_condition.conditions = [Conditions::Is.new(:integer_field, 1), Conditions::Is.new(:string_field, 'c')]

      table = Arel::Table.new(:parent_models)
      query = table.where(and_condition.scope(table)).project(Arel.sql('id')).to_sql

      ids = ParentModel.connection.execute(query).map { |r| r['id'] }
      expect(ids).to eq([@m3.id])
    end

    it 'or' do
      or_condition = Conditions::Or.new([])
      or_condition.conditions = [Conditions::Is.new(:integer_field, 1), Conditions::Is.new(:string_field, 'c')]

      table = Arel::Table.new(:parent_models)
      query = table.where(or_condition.scope(table)).project(Arel.sql('id')).to_sql

      ids = ParentModel.connection.execute(query).map { |r| r['id'] }
      expect(ids).to eq([@m1.id, @m3.id])
    end
  end
end