require File.dirname(__FILE__) + '/../test_helper'

class RoleReplacementsTest < ActionController::IntegrationTest
  fixtures :projects, :trackers, :issue_statuses, :issues,
           :enumerations, :users, :issue_categories,
           :projects_trackers,
           :roles,
           :member_roles,
           :members

  def setup
    @project = Project.find(1)
    @project.enable_module! :role_replacements

    @role_before = Role.non_member
    @role_after = Role.find(2)

    @project.role_replacements.create!({
        :role_before => @role_before,
        :role_after => @role_after
    })

    # users_004
    log_user('rhill', 'foo')
  end

  #def test_user_with_replaced_role_can_view_issues
  #  roles = @user.roles_for_project(@project)
  #  assert_include @role_after, roles
  #end
  #
  #def test_project_visible_to_user
  #  projects = Project.visible(@user)
  #  assert_include @project, projects
  #end

  def test_user_had_to_see_project_in_main_list
    url = url_for(
        :only_path => true,
        :controller => 'projects',
        :action => 'show',
        :id => @project
    )

    get '/projects'
    assert_tag :tag => 'a',
                  :attributes => {
                      :href => url
                  },
                  :parent => {
                      :tag => 'div',
                      :attributes => {
                          :class => 'root'
                      }
                  }
  end

  def test_user_cant_see_project_in_jump_box
    get '/projects'
    url = url_for(
        :only_path => true,
        :controller => 'projects',
        :action => 'show',
        :id => @project,
        :jump => 'overview'
    )
    assert_no_tag :tag => 'option',
               :content => @project.to_s,
               :attributes => {
                   :value => url,
               },
                :parent => {
                    :tag => 'select',
                    :parent => {
                        :tag => 'div',
                        :attributes => {
                            :id => 'quick-search'
                        }
                    }
                }
  end
end
