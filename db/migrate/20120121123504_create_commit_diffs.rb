class CreateCommitDiffs < ActiveRecord::Migration
  def self.up
    create_table :commit_diffs do |t|
      t.timestamps
      t.string :sha
    end
    
    add_column :commits, :commit_diff_id, :integer, :references => "commit_diff"
    add_index  :commits, :sha, :unique => true
    add_index  :commit_diffs, :sha, :unique => true
  end

  def self.down
    remove_index :commits, :sha
    remove_index :commit_diffs, :sha
    remove_column :commits, :commit_diff_id
    drop_table :commit_diffs
  end
end
