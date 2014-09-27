require 'spec_helper'

describe Conditions do
  before(:each) do
    Engine.clear
    TestTask.destroy_all
  end

  it 'is' do
    TestTask.trigger on: :after_update, if: {status: {is: 'solved'}} do
      TestTask.create kind: 'follow up'
    end

    task = TestTask.create
    expect(TestTask.count).to eq(1)

    task.update_attributes status: 'solved'
    expect(TestTask.count).to eq(2)
    expect(TestTask.all.last.kind).to eq('follow up')
  end

  it 'is_not' do
    TestTask.trigger on: :after_update, if: {status: {is_not: 'solved'}} do
      TestTask.create kind: 'follow up'
    end

    task = TestTask.create status: 'solved'
    expect(TestTask.count).to eq(1)

    task.update_attributes status: 'completed'
    expect(TestTask.count).to eq(2)
    expect(TestTask.all.last.kind).to eq('follow up')
  end

  it 'greater_then' do
    TestTask.trigger on: :after_update, if: {failure_count: {greater_then: 1}} do
      TestTask.create kind: 'follow up'
    end

    task = TestTask.create failure_count: 0
    expect(TestTask.count).to eq(1)

    task.update_attributes failure_count: 1
    expect(TestTask.count).to eq(1)

    task.update_attributes failure_count: 2
    expect(TestTask.count).to eq(2)
    expect(TestTask.all.last.kind).to eq('follow up')
  end

  it 'less_then' do
    TestTask.trigger on: :after_update, if: {failure_count: {less_then: 2}} do
      TestTask.create kind: 'follow up'
    end

    task = TestTask.create failure_count: 2
    expect(TestTask.count).to eq(1)

    task.update_attributes failure_count: 1
    expect(TestTask.count).to eq(2)
    expect(TestTask.all.last.kind).to eq('follow up')
  end

  it 'exists' do
    TestTask.trigger on: :after_update, if: {failure_count: {exists: true}} do
      TestTask.create kind: 'follow up'
    end

    task = TestTask.create
    expect(TestTask.count).to eq(1)

    task.update_attributes failure_count: 1
    expect(TestTask.count).to eq(2)
    expect(TestTask.all.last.kind).to eq('follow up')
  end

  it 'and' do
    TestTask.trigger on: :after_update, if: {and: [{status: {is: 'solved'}}, {kind: {is: 'service'}}]} do
      TestTask.create kind: 'follow up'
    end

    task = TestTask.create
    expect(TestTask.count).to eq(1)

    task.update_attributes status: 'solved', kind: 'service'
    expect(TestTask.count).to eq(2)
    expect(TestTask.all.last.kind).to eq('follow up')
  end

  it 'or' do
    TestTask.trigger on: :after_update, if: {or: [{status: {is: 'solved'}}, {kind: {is: 'service'}}]} do
      TestTask.create kind: 'follow up'
    end

    task = TestTask.create
    expect(TestTask.count).to eq(1)

    task.update_attributes status: 'solved'
    expect(TestTask.count).to eq(2)
    expect(TestTask.all.last.kind).to eq('follow up')

    task2 = TestTask.create
    expect(TestTask.count).to eq(3)

    task2.update_attributes kind: 'service'
    expect(TestTask.count).to eq(4)
    expect(TestTask.all.last.kind).to eq('follow up')
  end

  it 'in' do
    TestTask.trigger on: :after_update, if: {status: {in: ['solved', 'confirmed']}} do
      TestTask.create kind: 'follow up'
    end

    task = TestTask.create
    expect(TestTask.count).to eq(1)

    task.update_attributes status: 'solved'
    expect(TestTask.count).to eq(2)
    expect(TestTask.all.last.kind).to eq('follow up')

    task2 = TestTask.create
    expect(TestTask.count).to eq(3)

    task2.update_attributes status: 'confirmed'
    expect(TestTask.count).to eq(4)
    expect(TestTask.all.last.kind).to eq('follow up')
  end

  it 'lambda' do
    TestTask.trigger on: :after_update, if: -> (task) { task.status == 'solved' && task.kind == 'service' } do
      TestTask.create kind: 'follow up'
    end

    task = TestTask.create
    expect(TestTask.count).to eq(1)

    task.update_attributes status: 'solved', kind: 'service'
    expect(TestTask.count).to eq(2)
    expect(TestTask.all.last.kind).to eq('follow up')
  end
end
