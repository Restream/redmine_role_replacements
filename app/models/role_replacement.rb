class RoleReplacement < ActiveRecord::Base
  unloadable
  
  belongs_to :project
  belongs_to :role_before, :class_name => "Role"
  belongs_to :role_after, :class_name => "Role"

  validates_presence_of :project
  validates_presence_of :role_before
  validates_presence_of :role_after
  validates_uniqueness_of :role_before_id, :scope => :project_id
  
end
