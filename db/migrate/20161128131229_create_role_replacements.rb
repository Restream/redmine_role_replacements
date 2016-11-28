class CreateRoleReplacements < ActiveRecord::Migration
  def self.up
    create_table :role_replacements do |t|
      t.column :project_id, :integer
      t.column :role_before_id, :integer
      t.column :role_after_id, :integer

      t.timestamps
    end unless table_exists?(:role_replacements)
    add_index :role_replacements, :project_id unless index_exists?(:role_replacements, :project_id)
  end

  def self.down
    remove_index :role_replacements, :project_id
    drop_table :role_replacements
  end
end
