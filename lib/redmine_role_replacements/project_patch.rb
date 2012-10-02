module RedmineRoleReplacements
  module ProjectPatch
    def self.included(base)
      base.send :has_many, :role_replacements, :dependent => :destroy
      base.send :include, InstanceMethods
    end

    module InstanceMethods
      def non_replaced_roles
        replaced_roles = role_replacements.map &:role_before
        Role.sorted.select { |role| !replaced_roles.include?(role) }
      end
    end
  end
end
