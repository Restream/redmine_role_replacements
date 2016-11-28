require File.dirname(__FILE__) + '/../test_helper'

class ProjectTest < ActiveSupport::TestCase
  fixtures :projects, :trackers, :issue_statuses, :issues,
    :enumerations, :users, :issue_categories,
    :projects_trackers,
    :roles,
    :member_roles,
    :members

  def setup
    @project     = Project.find(1)
    @roles       = Role.all
    @role_before = Role.non_member
    @role_after  = Role.find(4)
    RoleReplacement.create!(
      project:     @project,
      role_before: @role_before,
      role_after:  @role_after)
  end

  def test_non_replaced_roles_does_not_include_replaced_role
    roles = @project.non_replaced_roles
    assert roles
    assert_not_include @role_before, roles
  end
end
