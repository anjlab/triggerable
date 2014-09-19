require 'active_record'

class TestTask < ActiveRecord::Base
  include Triggerable
end


# class ParentModel < ActiveRecord::Base
#   include ARTriggers::Automated
#   automate

#   has_many :child_models
# end

# class ChildModel < ActiveRecord::Base
#   belongs_to :parent_model
# end