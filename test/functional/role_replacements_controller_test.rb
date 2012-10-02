require File.dirname(__FILE__) + '/../test_helper'

class RoleReplacementsControllerTest < ActionController::TestCase
  fixtures :projects, :trackers, :issue_statuses, :issues,
           :enumerations, :users, :issue_categories,
           :projects_trackers,
           :roles,
           :member_roles,
           :members

  def setup
    @project = Project.find(1)
    @project.enable_module! :role_replacements

    # admin
    @user = User.find(1)
    User.current = @user

    @role_before = Role.non_member
    @role_after = Role.find(2)

    @request = ActionController::TestRequest.new
    @request.session[:user_id] = @user.id
  end

  def test_show_role_replacements_for_user
    @user = User.find(2)
    User.current = @user
    @request.session[:user_id] = @user.id
    user_role = Role.find(1)
    user_role.add_permission! :manage_role_replacements

    get :index, :project_id => @project.name
    assert_response :success
  end

  def test_show_role_replacements
    get :index, :project_id => @project.name
    assert_response :success
  end

  def test_show_new_role_replacement
    get :new, :project_id => @project.name
    assert_response :success
  end

  def test_create_role_replacement
    attrs = {
        :role_before_id => @role_before.id,
        :role_after_id => @role_after.id
    }
    post :create, :project_id => @project.name, :role_replacement => attrs
    assert_response :redirect
    role_replacement = @project.role_replacements.find(:first, :conditions => {
        :role_before_id => attrs[:role_before_id]
    })
    assert role_replacement
    assert_equal attrs[:role_after_id], role_replacement.role_after_id
  end

  def test_show_edit_role_replacement
    role_replacement = RoleReplacement.create!({
        :project_id => @project.id,
        :role_before_id => @role_before.id,
        :role_after_id => @role_after.id
    })
    get :edit, :project_id => @project.name, :id => role_replacement.id
    assert_response :success
  end

  def test_update_role_replacement
    role_replacement = @project.role_replacements.create!({
        :project_id => @project.id,
        :role_before_id => @role_before.id,
        :role_after_id => 5
    })
    attrs = {
        :role_before_id => @role_before.id,
        :role_after_id => @role_after.id
    }
    put :update, :project_id => @project.name, :id => role_replacement.id,
        :role_replacement => attrs
    assert_response :redirect
    role_replacement.reload
    assert_equal attrs[:role_after_id], role_replacement.role_after_id
  end

  def test_destroy_role_replacement
    role_replacement = RoleReplacement.create!({
        :project_id => @project.id,
        :role_before_id => @role_before.id,
        :role_after_id => @role_after.id
    })
    delete :destroy, :project_id => @project.name, :id => role_replacement.id
    assert_response :redirect
    role_replacement =  RoleReplacement.find_by_id role_replacement.id
    assert_nil role_replacement
  end
end
