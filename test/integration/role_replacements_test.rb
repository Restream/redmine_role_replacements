require File.dirname(__FILE__) + '/../test_helper'

class RoleReplacementsTest < Redmine::IntegrationTest
  fixtures :projects, :trackers, :issue_statuses, :issues,
    :enumerations, :users, :issue_categories, :email_addresses,
    :projects, :projects_trackers,
    :roles,
    :member_roles,
    :members

  def setup
    @role_anonymous    = Role.anonymous
    @role_non_member   = Role.non_member
    @role_member       = Role.find(2)
    @role_other_member = Role.find(1)
    @request           = ActionController::TestRequest.new
    User.current       = User.anonymous
  end

  def setup_private_project
    @project             = Project.find(2)
    @non_member          = User.find(4)
    @non_member_password = 'foo'
    @member              = User.find(2)
    @member_password     = 'jsmith'
    @project.enable_module! :role_replacements
  end

  def setup_public_project
    @project             = Project.find(1)
    @non_member          = User.find(4)
    @non_member_password = 'foo'
    @member              = User.find(2)
    @member_password     = 'jsmith'
    @project.enable_module! :role_replacements
  end

  def setup_member
    log_user(@member.login, @member_password)
    User.current = @member
  end

  def setup_non_member
    log_user(@non_member.login, @non_member_password)
    User.current = @non_member
  end

  def test_in_private_project_anonymous_should_not_change_to_non_member
    setup_private_project
    replacement = @project.role_replacements.create!({
      role_before: @role_anonymous,
      role_after:  @role_non_member
    })
    assert_equal false, replacement.valid_replacement?
    assert_project_not_visible_in_list(@project)
    assert_project_not_visible_in_jump_box(@project)
    assert_project_not_accessible(@project)
  end

  def test_in_private_project_anonymous_should_not_change_to_member
    setup_private_project
    replacement = @project.role_replacements.create!({
      role_before: @role_anonymous,
      role_after:  @role_member
    })
    assert_equal false, replacement.valid_replacement?
    assert_project_not_visible_in_list(@project)
    assert_project_not_visible_in_jump_box(@project)
    assert_project_not_accessible(@project)
  end

  def test_in_private_project_non_member_should_not_change_to_anonymous
    setup_private_project
    setup_non_member
    replacement = @project.role_replacements.create!({
      role_before: @role_non_member,
      role_after:  @role_anonymous
    })
    assert_equal false, replacement.valid_replacement?
    assert_project_not_visible_in_list(@project)
    assert_project_not_visible_in_jump_box(@project)
    assert_project_not_accessible(@project)
  end

  def test_in_private_project_non_member_should_not_change_to_member
    setup_private_project
    setup_non_member
    replacement = @project.role_replacements.create!({
      role_before: @role_non_member,
      role_after:  @role_anonymous
    })
    assert_equal false, replacement.valid_replacement?
    assert_project_not_visible_in_list(@project)
    assert_project_not_visible_in_jump_box(@project)
    assert_project_not_accessible(@project)
  end

  def test_in_private_project_member_should_not_change_to_anonymous
    setup_private_project
    setup_member
    replacement = @project.role_replacements.create!({
      role_before: @role_member,
      role_after:  @role_anonymous
    })
    assert_equal false, replacement.valid_replacement?
    assert_project_visible_in_list(@project)
    assert_project_visible_in_jump_box(@project)
    assert_project_accessible(@project)
  end

  def test_in_private_project_member_should_not_change_to_non_member
    setup_private_project
    setup_member
    replacement = @project.role_replacements.create!({
      role_before: @role_member,
      role_after:  @role_non_member
    })
    assert_equal false, replacement.valid_replacement?
    assert_project_visible_in_list(@project)
    assert_project_visible_in_jump_box(@project)
    assert_project_accessible(@project)
  end

  def test_in_private_project_member_should_change_to_other_member
    setup_private_project
    setup_member
    replacement = @project.role_replacements.create!({
      role_before: @role_member,
      role_after:  @role_other_member
    })
    assert replacement.valid_replacement?
    assert_project_visible_in_list(@project)
    assert_project_visible_in_jump_box(@project)
    assert_project_accessible(@project)
  end

  def test_in_public_project_anonymous_should_change_to_non_member
    setup_public_project
    replacement = @project.role_replacements.create!({
      role_before: @role_anonymous,
      role_after:  @role_non_member
    })
    assert replacement.valid_replacement?
    assert_project_visible_in_list(@project)
    assert_project_not_visible_in_jump_box(@project)
    assert_project_accessible(@project)
  end

  def test_in_public_project_anonymous_should_change_to_member
    setup_public_project
    replacement = @project.role_replacements.create!({
      role_before: @role_anonymous,
      role_after:  @role_member
    })
    assert replacement.valid_replacement?
    assert_project_visible_in_list(@project)
    assert_project_not_visible_in_jump_box(@project)
    assert_project_accessible(@project)
  end

  def test_in_public_project_non_member_should_change_to_anonymous
    setup_public_project
    setup_non_member
    replacement = @project.role_replacements.create!({
      role_before: @role_non_member,
      role_after:  @role_anonymous
    })
    assert replacement.valid_replacement?
    assert_project_visible_in_list(@project)
    assert_project_not_visible_in_jump_box(@project)
    assert_project_accessible(@project)
  end

  def test_in_public_project_non_member_should_change_to_member
    setup_public_project
    setup_non_member
    replacement = @project.role_replacements.create!({
      role_before: @role_non_member,
      role_after:  @role_member
    })
    assert replacement.valid_replacement?
    assert_project_visible_in_list(@project)
    assert_project_not_visible_in_jump_box(@project)
    assert_project_accessible(@project)
  end

  def test_in_public_project_member_should_change_to_anonymous
    setup_public_project
    setup_member
    replacement = @project.role_replacements.create!({
      role_before: @role_member,
      role_after:  @role_anonymous
    })
    assert replacement.valid_replacement?
    assert_project_visible_in_list(@project)
    assert_project_visible_in_jump_box(@project)
    assert_project_accessible(@project)
  end

  def test_in_public_project_member_should_change_to_non_member
    setup_public_project
    setup_member
    replacement = @project.role_replacements.create!({
      role_before: @role_member,
      role_after:  @role_non_member
    })
    assert replacement.valid_replacement?
    assert_project_visible_in_list(@project)
    assert_project_visible_in_jump_box(@project)
    assert_project_accessible(@project)
  end

  def test_in_public_project_member_should_change_to_member
    setup_public_project
    setup_member
    replacement = @project.role_replacements.create!({
      role_before: @role_member,
      role_after:  @role_other_member
    })
    assert replacement.valid_replacement?
    assert_project_visible_in_list(@project)
    assert_project_visible_in_jump_box(@project)
    assert_project_accessible(@project)
  end
end
