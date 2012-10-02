module RedmineRoleReplacements
  module UserPatch
    def self.included(base)
      base.send :include, InstanceMethods
      base.send :alias_method_chain, :roles_for_project, :replacements
      base.send :alias_method_chain, :projects_by_role, :replacements
    end

    module InstanceMethods
      def roles_for_project_with_replacements(project)
        roles = roles_for_project_without_replacements(project)
        
        if project.module_enabled?(:role_replacements)
          roles.map do |role|
            role_replacement = project.role_replacements.find_by_role_before_id(role.id)
            # replace role
            (role_replacement && role_replacement.role_after) || role
          end
        else
          roles
        end  
      end

      def projects_by_role_with_replacements
        return @projects_by_role_with_replacements if @projects_by_role_with_replacements 
        by_roles = projects_by_role_without_replacements
        Role.builtin(true).each { |role| by_roles[role] ||= [] }
        RoleReplacement.find_each do |role_replacement|
          if by_roles.keys.include?(role_replacement.role_before)
            # first remove project by role_before
            by_roles[role_replacement.role_before].delete(role_replacement.project)
            # then add project by role_after
            by_roles[role_replacement.role_after] << role_replacement.project
          end
        end
        @projects_by_role_with_replacements = by_roles.delete_if { |role, projects| projects.empty? } 
      end
    end
  end
end
