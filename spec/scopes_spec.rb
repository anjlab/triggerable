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
      ids = model_ids_for(Triggerable::Conditions::Is, 1)
      expect(ids).to eq([@m1.id, @m3.id])
    end

    it 'greater than' do
      ids = model_ids_for(Triggerable::Conditions::GreaterThan, 1)
      expect(ids).to eq([@m2.id])
    end

    it 'less than' do
      ids = model_ids_for(Triggerable::Conditions::LessThan, 2)
      expect(ids).to eq([@m1.id, @m3.id])
    end

    it 'is not' do
      ids = model_ids_for(Triggerable::Conditions::IsNot, 2)
      expect(ids).to eq([@m1.id, @m3.id])
    end

    it 'greater than or equal' do
      ids = model_ids_for(Triggerable::Conditions::LessThanOrEqualTo, 2)
      expect(ids).to eq([@m1.id, @m2.id, @m3.id])
    end

    it 'less than or equal' do
      ids = model_ids_for(Triggerable::Conditions::GreaterThanOrEqualTo, 1)
      expect(ids).to eq([@m1.id, @m2.id, @m3.id])
    end

    it 'in' do
      ids = model_ids_for(Triggerable::Conditions::In, [1, 2])
      expect(ids).to eq([@m1.id, @m2.id, @m3.id])
    end
  end

  context 'predicates' do
    def model_ids_for condition_class, conditions
      and_condition = condition_class.new([])
      and_condition.conditions = [Triggerable::Conditions::Is.new(:integer_field, 1), Triggerable::Conditions::Is.new(:string_field, 'c')]

      table = Arel::Table.new(:parent_models)
      query = table.where(and_condition.scope(table)).project(Arel.sql('id')).to_sql

      ParentModel.connection.execute(query).map { |r| r['id'] }
    end

    it 'and' do
      ids = model_ids_for Triggerable::Conditions::And, [Triggerable::Conditions::Is.new(:integer_field, 1), Triggerable::Conditions::Is.new(:string_field, 'c')]
      expect(ids).to eq([@m3.id])
    end

    it 'or' do
      ids = model_ids_for Triggerable::Conditions::Or, [Triggerable::Conditions::Is.new(:integer_field, 1), Triggerable::Conditions::Is.new(:string_field, 'c')]
      expect(ids).to eq([@m1.id, @m3.id])
    end
  end
end