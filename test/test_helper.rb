# Load the normal Rails helper
require File.expand_path('../../../../test/test_helper', File.dirname(__FILE__))

# Ensure that we are using the temporary fixture path
# Engines::Testing.set_fixture_path

def init_role_replacement_module(project)
  project.enable_module! :redmine_role_replacements
  Role.find(1).add_permission! :manage_role_replacements
end
