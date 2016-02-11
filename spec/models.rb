require 'active_record'

class TestTask < ActiveRecord::Base
  def solved?
    status == 'solved'
  end

  def true_method
    true
  end

  def false_method
    false
  end
end

class ScopedTestTask < TestTask
  default_scope { where(id: nil) }
end

class ParentModel < ActiveRecord::Base
  has_many :child_models
end

class ChildModel < ActiveRecord::Base
  belongs_to :parent_model
end
