class RoleReplacement < ActiveRecord::Base
  unloadable

  belongs_to :project
  belongs_to :role_before, class_name: 'Role'
  belongs_to :role_after, class_name: 'Role'

  validates_presence_of :project
  validates_presence_of :role_before
  validates_presence_of :role_after
  validates_uniqueness_of :role_before_id, scope: :project_id

  scope :for_active_projects, -> {
    joins(:project).where("#{Project.table_name}.status = ?", Project::STATUS_ACTIVE)
  }

  # 1. replacements where "role_before == role_after" are invalid
  # 2. for public projects all replacements are valid
  # 3. for private projects valid only replacements like member -> member
  def valid_replacement?
    return false if role_before == role_after
    return true if project.is_public?
    role_before.member? && role_after.member?
  end

  # Solving problem with scoped Project
  def project
    super || ( project_id && Project.unscoped.find(project_id) )
  end
end
