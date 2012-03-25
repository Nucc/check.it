class CreateReactions < ActiveRecord::Migration
  def self.up
    create_table :reactions do |t|
      t.integer :commit_diff_id
      t.integer :user_id
      t.integer :status

      t.timestamps
    end
  end

  def self.down
    drop_table :reactions
  end
end
