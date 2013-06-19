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

        if project && project.module_enabled?(:role_replacements)
          # replace role if replacement is valid
          roles.map do |role|
            replacement = project.role_replacements.find_by_role_before_id(role.id)
            if replacement && replacement.valid_replacement?
              replacement.role_after
            else
              role
            end
          end
        else
          roles
        end
      end

      def projects_by_role_with_replacements
        hash = projects_by_role_without_replacements

        replacements = RoleReplacement.for_active_projects

        replacements.each do |replacement|
          next unless replacement.valid_replacement?

          if replacement.role_before.member?
            if hash[replacement.role_before].detect(replacement.project)
              hash[replacement.role_before].delete_if { |p| p == replacement.project }
              hash[replacement.role_after] = [] unless hash.key?(replacement.role_after)
              hash[replacement.role_after] << replacement.project
            end
          else
            roles_before = roles_for_project_without_replacements(replacement.project)
            if roles_before.include?(replacement.role_before) && replacement.role_after.member?
              hash[replacement.role_after] = [] unless hash.key?(replacement.role_after)
              hash[replacement.role_after] << replacement.project
            end
          end
        end

        hash.each do |role, projects|
          projects.uniq!
        end

        hash.keep_if { |role, projects| projects.any? }
      end

    end
  end
end
