require 'spec_helper'

describe 'Automations' do
  before(:each) do
    Triggerable::Engine.clear
    TestTask.destroy_all
  end

  it 'after' do
    constantize_time_now Time.utc 2012, 9, 1, 12, 00

    TestTask.automation if: {and: [{updated_at: {after: 24.hours}}, {status: {is: :solved}}, {kind: {is: :service}}]} do
      TestTask.create kind: 'follow up'
    end

    task = TestTask.create
    expect(TestTask.count).to eq(1)
    task.update_attributes status: 'solved', kind: 'service'
    expect(TestTask.count).to eq(1)

    constantize_time_now Time.utc 2012, 9, 1, 20, 00
    Triggerable::Engine.run_automations(1.hour)
    expect(TestTask.count).to eq(1)

    constantize_time_now Time.utc 2012, 9, 2, 12, 00
    Triggerable::Engine.run_automations(1.hour)

    expect(TestTask.count).to eq(2)
    expect(TestTask.all.last.kind).to eq('follow up')
  end

  it 'before' do
    constantize_time_now Time.utc 2012, 9, 1, 12, 00

    TestTask.automation if: {and: [{scheduled_at: {before: 2.hours}}, {status: {is: :solved}}, {kind: {is: :service}}]} do
      TestTask.create kind: 'follow up'
    end

    task = TestTask.create scheduled_at: Time.utc(2012, 9, 1, 20, 00)
    expect(TestTask.count).to eq(1)
    task.update_attributes status: 'solved', kind: 'service'
    expect(TestTask.count).to eq(1)

    constantize_time_now Time.utc 2012, 9, 1, 15, 00
    Triggerable::Engine.run_automations(1.hour)
    expect(TestTask.count).to eq(1)

    constantize_time_now Time.utc 2012, 9, 1, 18, 00
    Triggerable::Engine.run_automations(1.hour)
    expect(TestTask.count).to eq(2)
    expect(TestTask.all.last.kind).to eq('follow up')
  end

  it 'after 30 mins with 30 mins interval' do
    constantize_time_now Time.utc 2012, 9, 1, 12, 00

    TestTask.automation if: {and: [{updated_at: {after: 30.minutes}}, {status: {is: :solved}}, {kind: {is: :service}}]} do
      TestTask.create kind: 'follow up'
    end

    task = TestTask.create
    expect(TestTask.count).to eq(1)
    task.update_attributes status: 'solved', kind: 'service'
    expect(TestTask.count).to eq(1)

    constantize_time_now Time.utc 2012, 9, 1, 12, 29
    Triggerable::Engine.run_automations(30.minutes)
    expect(TestTask.count).to eq(1)

    constantize_time_now Time.utc 2012, 9, 1, 12, 30
    Triggerable::Engine.run_automations(30.minutes)

    expect(TestTask.count).to eq(2)
    expect(TestTask.all.last.kind).to eq('follow up')
  end

  it 'before 30 mins with 30 mins interval' do
    constantize_time_now Time.utc 2012, 9, 1, 12, 00

    TestTask.automation if: {and: [{scheduled_at: {before: 30.minutes}}, {status: {is: :solved}}, {kind: {is: :service}}]} do
      TestTask.create kind: 'follow up'
    end

    task = TestTask.create scheduled_at: Time.utc(2012, 9, 1, 15, 35)
    task.update_attributes status: 'solved', kind: 'service'
    expect(TestTask.count).to eq(1)

    constantize_time_now Time.utc 2012, 9, 1, 14, 31
    Triggerable::Engine.run_automations(30.minutes)
    expect(TestTask.count).to eq(1)

    constantize_time_now Time.utc 2012, 9, 1, 15, 03
    Triggerable::Engine.run_automations(30.minutes)
    expect(TestTask.count).to eq(2)
    expect(TestTask.all.last.kind).to eq('follow up')
  end

  it 'after 2 hour with 4 hours interval' do
    constantize_time_now Time.utc 2012, 9, 1, 11, 55

    TestTask.automation if: {and: [{updated_at: {after: 2.hours}}, {status: {is: :solved}}, {kind: {is: :service}}]} do
      TestTask.create kind: 'follow up'
    end

    task = TestTask.create
    expect(TestTask.count).to eq(1)
    task.update_attributes status: 'solved', kind: 'service'
    expect(TestTask.count).to eq(1)

    constantize_time_now Time.utc 2012, 9, 1, 12, 00
    Triggerable::Engine.run_automations(4.hours)
    expect(TestTask.count).to eq(1)

    constantize_time_now Time.utc 2012, 9, 1, 16, 00
    Triggerable::Engine.run_automations(4.hours)

    expect(TestTask.count).to eq(2)
    expect(TestTask.all.last.kind).to eq('follow up')
  end

  it 'before 4 hour with 2 hour interval' do
    constantize_time_now Time.utc 2012, 9, 1, 12, 00

    TestTask.automation if: {and: [{scheduled_at: {before: 4.hour}}, {status: {is: :solved}}, {kind: {is: :service}}]} do
      TestTask.create kind: 'follow up'
    end

    task = TestTask.create scheduled_at: Time.utc(2012, 9, 1, 15, 35)
    task.update_attributes status: 'solved', kind: 'service'
    expect(TestTask.count).to eq(1)

    constantize_time_now Time.utc 2012, 9, 1, 04, 05
    Triggerable::Engine.run_automations(2.hour)
    expect(TestTask.count).to eq(1)

    constantize_time_now Time.utc 2012, 9, 1, 10, 01
    Triggerable::Engine.run_automations(2.hour)
    expect(TestTask.count).to eq(2)
    expect(TestTask.all.last.kind).to eq('follow up')
  end

  it 'after 2 hour with 15 minutes interval' do
    constantize_time_now Time.utc 2012, 9, 1, 11, 55

    TestTask.automation if: {and: [{updated_at: {after: 2.hours}}, {status: {is: :solved}}, {kind: {is: :service}}]} do
      TestTask.create kind: 'follow up'
    end

    task = TestTask.create
    expect(TestTask.count).to eq(1)
    task.update_attributes status: 'solved', kind: 'service'
    expect(TestTask.count).to eq(1)

    constantize_time_now Time.utc 2012, 9, 1, 11, 46
    Triggerable::Engine.run_automations(15.minutes)
    expect(TestTask.count).to eq(1)

    constantize_time_now Time.utc 2012, 9, 1, 13, 46
    Triggerable::Engine.run_automations(15.minutes)
    expect(TestTask.count).to eq(1)

    constantize_time_now Time.utc 2012, 9, 1, 14, 02
    Triggerable::Engine.run_automations(15.minutes)

    expect(TestTask.count).to eq(2)
    expect(TestTask.all.last.kind).to eq('follow up')

    constantize_time_now Time.utc 2012, 9, 1, 14, 17
    Triggerable::Engine.run_automations(15.minutes)
    expect(TestTask.count).to eq(2)
  end

  it 'before 2 hour with 15 minutes interval' do
    constantize_time_now Time.utc 2012, 9, 1, 12, 00

    TestTask.automation if: {and: [{scheduled_at: {before: 2.hour}}, {status: {is: :solved}}, {kind: {is: :service}}]} do
      TestTask.create kind: 'follow up'
    end

    task = TestTask.create scheduled_at: Time.utc(2012, 9, 1, 15, 35)
    task.update_attributes status: 'solved', kind: 'service'
    expect(TestTask.count).to eq(1)

    constantize_time_now Time.utc 2012, 9, 1, 10, 05
    Triggerable::Engine.run_automations(15.minutes)
    expect(TestTask.count).to eq(1)

    constantize_time_now Time.utc 2012, 9, 1, 13, 30
    Triggerable::Engine.run_automations(15.minutes)
    expect(TestTask.count).to eq(2)
    expect(TestTask.all.last.kind).to eq('follow up')

    constantize_time_now Time.utc 2012, 9, 1, 15, 32
    Triggerable::Engine.run_automations(15.minutes)
    expect(TestTask.count).to eq(2)
  end
end
