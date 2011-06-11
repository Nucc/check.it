class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.commit         :commit_id, :null => false
      t.string         :opinion, :null => false
      t.integer        :block, :null => false
      t.integer        :line, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
