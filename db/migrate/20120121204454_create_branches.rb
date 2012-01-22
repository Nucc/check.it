class CreateBranches < ActiveRecord::Migration
  def self.up
    create_table :branches do |t|
      t.string :name
      t.string :repository
      t.timestamps
    end
    
    add_index  :branches, [:name, :repository], :unique => true
    add_column :commits, :branch_id, :integer, :references => "branch"
  end

  def self.down
    drop_table :branches
    remove_column :commits, :branch_id
  end
end
