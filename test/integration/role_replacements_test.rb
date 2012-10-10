require File.dirname(__FILE__) + '/../test_helper'

class RoleReplacementsTest < ActionController::IntegrationTest
  fixtures :projects, :trackers, :issue_statuses, :issues,
           :enumerations, :users, :issue_categories,
           :projects_trackers,
           :roles,
           :member_roles,
           :members

  def setup
    @role_anonymous = Role.anonymous
    @role_non_member = Role.non_member
    @role_member = Role.find(2)
    @role_other_member = Role.find(1)
    @request = ActionController::TestRequest.new
  end

  context "in private project" do
    setup do
      @project = Project.find(2)
      @non_member = User.find(4)
      @non_member_password = "foo"
      @member = User.find(2)
      @member_password = "jsmith"
      @project.enable_module! :role_replacements
    end
    context "anonymous" do
      should "not change on non member" do
        replacement = @project.role_replacements.create!({
            :role_before => @role_anonymous,
            :role_after => @role_non_member
        })
        assert_false replacement.valid_replacement?
        assert_project_not_visible_in_list(@project)
        assert_project_not_visible_in_jump_box(@project)
        assert_project_not_accessible(@project)
      end
      should "not change on member" do
        replacement = @project.role_replacements.create!({
            :role_before => @role_anonymous,
            :role_after => @role_member
        })
        assert_false replacement.valid_replacement?
        assert_project_not_visible_in_list(@project)
        assert_project_not_visible_in_jump_box(@project)
        assert_project_not_accessible(@project)
      end
    end
    context "non member" do
      setup do
        log_user(@non_member.login, @non_member_password)
      end
      should "not change on anonymous" do
        replacement = @project.role_replacements.create!({
            :role_before => @role_non_member,
            :role_after => @role_anonymous
        })
        assert_false replacement.valid_replacement?
        assert_project_not_visible_in_list(@project)
        assert_project_not_visible_in_jump_box(@project)
        assert_project_not_accessible(@project)
      end
      should "not change on member" do
        replacement = @project.role_replacements.create!({
            :role_before => @role_non_member,
            :role_after => @role_member
        })
        assert_false replacement.valid_replacement?
        assert_project_not_visible_in_list(@project)
        assert_project_not_visible_in_jump_box(@project)
        assert_project_not_accessible(@project)
      end
    end
    context "member" do
      setup do
        log_user(@member.login, @member_password)
      end
      should "not change on anonymous" do
        replacement = @project.role_replacements.create!({
            :role_before => @role_member,
            :role_after => @role_anonymous
        })
        assert_false replacement.valid_replacement?
        assert_project_visible_in_list(@project)
        assert_project_visible_in_jump_box(@project)
        assert_project_accessible(@project)
      end
      should "not change on non member" do
        replacement = @project.role_replacements.create!({
            :role_before => @role_member,
            :role_after => @role_non_member
        })
        assert_false replacement.valid_replacement?
        assert_project_visible_in_list(@project)
        assert_project_visible_in_jump_box(@project)
        assert_project_accessible(@project)
      end
      should "change on other member" do
        replacement = @project.role_replacements.create!({
            :role_before => @role_member,
            :role_after => @role_other_member
        })
        assert replacement.valid_replacement?
        assert_project_visible_in_list(@project)
        assert_project_visible_in_jump_box(@project)
        assert_project_accessible(@project)
      end
    end
  end

  context "in public project" do
    setup do
      @project = Project.find(1)
      @non_member = User.find(4)
      @non_member_password = "foo"
      @member = User.find(2)
      @member_password = "jsmith"
      @project.enable_module! :role_replacements
    end
    context "anonymous" do
      should "change on non member" do
        replacement = @project.role_replacements.create!({
            :role_before => @role_anonymous,
            :role_after => @role_non_member
        })
        assert replacement.valid_replacement?
        assert_project_visible_in_list(@project)
        assert_project_not_visible_in_jump_box(@project)
        assert_project_accessible(@project)
      end
      should "change on member" do
        replacement = @project.role_replacements.create!({
            :role_before => @role_anonymous,
            :role_after => @role_member
        })
        assert replacement.valid_replacement?
        assert_project_visible_in_list(@project)
        assert_project_not_visible_in_jump_box(@project)
        assert_project_accessible(@project)
      end
    end
    context "non member" do
      setup do
        log_user(@non_member.login, @non_member_password)
      end
      should "change on anonymous" do
        replacement = @project.role_replacements.create!({
            :role_before => @role_non_member,
            :role_after => @role_anonymous
        })
        assert replacement.valid_replacement?
        assert_project_visible_in_list(@project)
        assert_project_not_visible_in_jump_box(@project)
        assert_project_accessible(@project)
      end
      should "change on member" do
        replacement = @project.role_replacements.create!({
            :role_before => @role_non_member,
            :role_after => @role_member
        })
        assert replacement.valid_replacement?
        assert_project_visible_in_list(@project)
        assert_project_not_visible_in_jump_box(@project)
        assert_project_accessible(@project)
      end
    end
    context "member" do
      setup do
        log_user(@member.login, @member_password)
      end
      should "change on anonymous" do
        replacement = @project.role_replacements.create!({
            :role_before => @role_member,
            :role_after => @role_anonymous
        })
        assert replacement.valid_replacement?
        assert_project_visible_in_list(@project)
        assert_project_visible_in_jump_box(@project)
        assert_project_accessible(@project)
      end
      should "change on non member" do
        replacement = @project.role_replacements.create!({
            :role_before => @role_anonymous,
            :role_after => @role_non_member
        })
        assert replacement.valid_replacement?
        assert_project_visible_in_list(@project)
        assert_project_visible_in_jump_box(@project)
        assert_project_accessible(@project)
      end
      should "change on member" do
        replacement = @project.role_replacements.create!({
            :role_before => @role_anonymous,
            :role_after => @role_member
        })
        assert replacement.valid_replacement?
        assert_project_visible_in_list(@project)
        assert_project_visible_in_jump_box(@project)
        assert_project_accessible(@project)
      end
    end
  end
end
