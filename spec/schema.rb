ActiveRecord::Schema.define do
  self.verbose = false

  create_table :test_tasks do |t|
    t.string :kind
    t.string :status
    t.integer :failure_count
    t.datetime :scheduled_at
    t.timestamps
  end

  create_table :parent_models, force: true do |t|
    t.string :string_field
    t.integer :integer_field

    t.timestamps
  end

  create_table :child_models, force: true do |t|
    t.string :string_field
    t.integer :integer_field
    t.integer :parent_model_id

    t.timestamps
  end

end