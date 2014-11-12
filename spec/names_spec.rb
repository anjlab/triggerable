require 'spec_helper'

describe 'Naming' do
  before(:each) do
    Engine.clear
    TestTask.destroy_all
  end

  it 'trigger name is available in body' do
    name = 'Create followup'
    TestTask.trigger name: name, on: :before_update, if: { status: { is: 'solved' } } do |trigger_name|
      self.kind = trigger_name
    end

    task = TestTask.create
    task.update_attributes status: 'solved'
    expect(task.kind).to eq(name)
  end
end