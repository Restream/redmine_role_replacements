# Load the normal Rails helper
require File.expand_path('../../../../test/test_helper', File.dirname(__FILE__))

# Ensure that we are using the temporary fixture path
# Engines::Testing.set_fixture_path

def init_role_replacement_module(project)
  project.enable_module! :redmine_role_replacements
  Role.find(1).add_permission! :manage_role_replacements
end

def project_path(project)
  url_for :only_path => true, :controller => 'projects', :action => 'show', 
      :id => project
end

def project_jump_path(project)
  url_for :only_path => true, :controller => 'projects', :action => 'show',
      :id => project, :jump => 'overview'
end

def assert_project_visible_in_list(project)
  get '/projects'
  assert_tag :tag => 'a', :attributes => { :href => project_path(project) },
      :parent => { :tag => 'div', :attributes => { :class => 'root' } }
end

def assert_project_not_visible_in_list(project)
  get '/projects'
  assert_no_tag :tag => 'a', :attributes => { :href => project_path(project) },
      :parent => { :tag => 'div', :attributes => { :class => 'root' } }
end

def assert_project_visible_in_jump_box(project)
  get '/projects'
  assert_tag :tag => 'option', :content => project.to_s,
      :attributes => { :value => project_jump_path(project) },
      :parent => { :tag => 'select', :parent => { :tag => 'div',
          :attributes => { :id => 'quick-search' } } }
end

def assert_project_not_visible_in_jump_box(project)
  get '/projects'
  assert_no_tag :tag => 'option', :content => project.to_s,
      :attributes => { :value => project_jump_path(project) },
      :parent => { :tag => 'select', :parent => { :tag => 'div',
          :attributes => { :id => 'quick-search' } } }
end

def assert_project_accessible(project)
  get project_path(project)
  assert_response :success
  #TODO: view issue, view issue in list
end

def assert_project_not_accessible(project)
  get project_path(project)
  assert_false response.success?, response.status
end
