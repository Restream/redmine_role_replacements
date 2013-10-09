# Load the normal Rails helper
require File.expand_path('../../../test/test_helper', File.dirname(__FILE__))

# Ensure that we are using the temporary fixture path
# Engines::Testing.set_fixture_path
class ActiveSupport::TestCase
  def init_role_replacement_module(project)
    project.enable_module! :redmine_role_replacements
    Role.find(1).add_permission! :manage_role_replacements
  end

  def project_path(project)
    url_for :only_path => true, :controller => 'projects', :action => 'show',
        :id => project
  end

  def assert_project_visible_in_list(project)
    assert_equal 1, Project.visible.where('projects.id = ?',project.id).count,
                 "Project #{project.id} should be visible for user #{User.current.id}"
  end

  def assert_project_not_visible_in_list(project)
    assert_equal 0, Project.visible.where('projects.id = ?', project.id).count,
                 "Project #{project.id} should not be visible for user #{User.current.id}"
  end

  def assert_project_visible_in_jump_box(project)
    assert_equal 1, User.current.projects.where('projects.id = ?', project.id).count,
                 "User #{User.current.id} should be a member of project #{project.id}"
  end

  def assert_project_not_visible_in_jump_box(project)
    assert_equal 0, User.current.projects.where('projects.id = ?', project.id).count,
                 "User #{User.current.id} should not be a member of project #{project.id}"
  end

  def assert_project_accessible(project)
    get project_path(project)
    assert_response :success
    #TODO: view issue, view issue in list
  end

  def assert_project_not_accessible(project)
    get project_path(project)
    assert_equal false, response.success?, response.status
  end
end
