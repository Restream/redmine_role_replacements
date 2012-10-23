require 'redmine'
require 'dispatcher'

Dispatcher.to_prepare do
  require_dependency 'project'
  require_dependency 'user'
  unless Project.included_modules.include? RedmineRoleReplacements::ProjectPatch
    Project.send :include, RedmineRoleReplacements::ProjectPatch
  end
  unless User.included_modules.include? RedmineRoleReplacements::UserPatch
    User.send :include, RedmineRoleReplacements::UserPatch
  end
end

Redmine::Plugin.register :redmine_role_replacements do
  name 'Redmine Role Replacements plugin'
  author 'Danil Tashkinov'
  description 'Redmine plugin for per-project role replacements'
  version '0.0.4'
  url 'https://github.com/Undev/redmine_role_replacements'
  author_url 'https://github.com/Undev'

  project_module :role_replacements do
    permission :manage_role_replacements,
                { :role_replacements => [:index, :new, :create, :edit, :update, :destroy] },
                :require => :loggedin
  end

  menu :project_menu,
       :role_replacements,
       { :controller => 'role_replacements', :action => 'index' },
       :param => :project_id,
       :after => :settings
end
