require 'spec_helper'

describe Conditions do
  before(:each) do
    class Sample; attr_accessor(:field); end
    @obj = Sample.new
  end

  context 'is' do

    def check_value value
      Conditions::Is.new(:field, value).true_for?(@obj)
    end

    def scope value
      Conditions::Is.new(:field, value).scope
    end

    context 'true_for' do
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

    context 'scope' do
      it('integer') { expect(scope(1)).to eq("field = 1") }
      it('string')  { expect(scope('1')).to eq("field = '1'") }
    end
  end

  context 'is_not' do

    def check_value value
      Conditions::IsNot.new(:field, value).true_for?(@obj)
    end

    def scope value
      Conditions::IsNot.new(:field, value).scope
    end

    context 'true_for' do
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

    context 'scope' do
      it('integer') { expect(scope(1)).to eq("field <> 1") }
      it('string')  { expect(scope('1')).to eq("field <> '1'") }
    end
  end

  context 'greater_then' do
    def check_value value
      Conditions::GreaterThen.new(:field, value).true_for?(@obj)
    end

    def scope value
      Conditions::GreaterThen.new(:field, value).scope
    end

    context 'true_for' do
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

    context 'scope' do
      it('integer') { expect(scope(1)).to   eq("field > 1")   }
      it('float')   { expect(scope(1.2)).to eq("field > 1.2") }
    end
  end

  context 'less_then' do
    def check_value value
      Conditions::LessThen.new(:field, value).true_for?(@obj)
    end

    def scope value
      Conditions::LessThen.new(:field, value).scope
    end

    context 'true_for' do
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

    context 'scope' do
      it('integer') { expect(scope(1)).to   eq("field < 1")   }
      it('float')   { expect(scope(1.2)).to eq("field < 1.2") }
    end
  end

  context 'in' do
    def check_value value
      Conditions::In.new(:field, value).true_for?(@obj)
    end

    def scope value
      Conditions::In.new(:field, value).scope
    end

    context 'true_for' do
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

    context 'scope' do
      it('integer') { expect(scope([1, 2, 3])).to       eq("field IN (1,2,3)")       }
      it('float')   { expect(scope([1.0, 1.2, 2.3])).to eq("field IN (1.0,1.2,2.3)") }
      it('string')  { expect(scope(['1', '2', '3'])).to eq("field IN ('1','2','3')") }
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
      before(:each) { @and_condition = Conditions::And.new([]) }

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
      before(:each) { @or_condition = Conditions::Or.new([]) }

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