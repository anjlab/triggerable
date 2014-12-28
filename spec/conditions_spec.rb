require 'spec_helper'

describe Triggerable::Conditions do
  before(:each) do
    class Sample; attr_accessor(:field); end
    @obj = Sample.new
  end

  context 'is' do

    def check_value value
      Triggerable::Conditions::Is.new(:field, value).true_for?(@obj)
    end

    def scope value
      Triggerable::Conditions::Is.new(:field, value).scope
    end

    it 'integer' do
      @obj.field = 1
      expect(check_value(1)).to be_truthy

      @obj.field = 2
      expect(check_value(1)).to be_falsy
    end

    it 'string' do
      @obj.field = '1'
      expect(check_value('1')).to be_truthy

      @obj.field = '2'
      expect(check_value('1')).to be_falsy
    end
  end

  context 'is_not' do

    def check_value value
      Triggerable::Conditions::IsNot.new(:field, value).true_for?(@obj)
    end

    def scope value
      Triggerable::Conditions::IsNot.new(:field, value).scope
    end

    it 'integer' do
      @obj.field = 1
      expect(check_value(2)).to be_truthy

      @obj.field = 2
      expect(check_value(2)).to be_falsy
    end

    it 'string' do
      @obj.field = '1'
      expect(check_value('2')).to be_truthy

      @obj.field = '2'
      expect(check_value('2')).to be_falsy
    end
  end

  context 'greater_than' do
    def check_value value
      Triggerable::Conditions::GreaterThan.new(:field, value).true_for?(@obj)
    end

    def scope value
      Triggerable::Conditions::GreaterThan.new(:field, value).scope
    end

    it 'integer' do
      @obj.field = 1

      expect(check_value(-1)).to be_truthy
      expect(check_value(0)).to  be_truthy
      expect(check_value(1)).to  be_falsy
      expect(check_value(2)).to  be_falsy
    end

    it 'float' do
      @obj.field = 1.0

      expect(check_value(0)).to   be_truthy
      expect(check_value(0.9)).to be_truthy
      expect(check_value(1.1)).to be_falsy
      expect(check_value(2)).to   be_falsy
    end
  end

  context 'less_than' do
    def check_value value
      Triggerable::Conditions::LessThan.new(:field, value).true_for?(@obj)
    end

    def scope value
      Triggerable::Conditions::LessThan.new(:field, value).scope
    end

    it 'integer' do
      @obj.field = 1

      expect(check_value(-1)).to be_falsy
      expect(check_value(0)).to  be_falsy
      expect(check_value(1)).to  be_falsy
      expect(check_value(2)).to  be_truthy
    end

    it 'float' do
      @obj.field = 1.0

      expect(check_value(0)).to   be_falsy
      expect(check_value(0.9)).to be_falsy
      expect(check_value(1.1)).to be_truthy
      expect(check_value(2)).to   be_truthy
    end
  end

  context 'in' do
    def check_value value
      Triggerable::Conditions::In.new(:field, value).true_for?(@obj)
    end

    def scope value
      Triggerable::Conditions::In.new(:field, value).scope
    end

    it 'integer' do
      @obj.field = 1

      expect(check_value([0])).to    be_falsy
      expect(check_value([1])).to    be_truthy
      expect(check_value([1, 2])).to be_truthy
    end

    it 'float' do
      @obj.field = 1.0

      expect(check_value([0.0])).to      be_falsy
      expect(check_value([1.0])).to      be_truthy
      expect(check_value([1.0, 2.0])).to be_truthy
    end

    it 'string' do
      @obj.field = '1'

      expect(check_value(['0'])).to      be_falsy
      expect(check_value(['1'])).to      be_truthy
      expect(check_value(['1', '2'])).to be_truthy
    end
  end

  context 'predicates' do
    class TrueCondition
      def true_for?(object); true; end
    end

    class FalseCondition
      def true_for?(object); false; end
    end

    context 'and' do
      before(:each) { @and_condition = Triggerable::Conditions::And.new([]) }

      it ('true + true') do
        @and_condition.conditions = [TrueCondition.new, TrueCondition.new]
        expect(@and_condition.true_for?(@obj)).to be_truthy
      end

      it ('true + false') do
        @and_condition.conditions = [TrueCondition.new, FalseCondition.new]
        expect(@and_condition.true_for?(@obj)).to be_falsy
      end

      it ('true + false') do
        @and_condition.conditions = [FalseCondition.new, FalseCondition.new]
        expect(@and_condition.true_for?(@obj)).to be_falsy
      end
    end

    context 'or' do
      before(:each) { @or_condition = Triggerable::Conditions::Or.new([]) }

      it ('true + true') do
        @or_condition.conditions = [TrueCondition.new, TrueCondition.new]
        expect(@or_condition.true_for?(@obj)).to be_truthy
      end

      it ('true + false') do
        @or_condition.conditions = [TrueCondition.new, FalseCondition.new]
        expect(@or_condition.true_for?(@obj)).to be_truthy
      end

      it ('true + false') do
        @or_condition.conditions = [FalseCondition.new, FalseCondition.new]
        expect(@or_condition.true_for?(@obj)).to be_falsy
      end
    end
  end
end