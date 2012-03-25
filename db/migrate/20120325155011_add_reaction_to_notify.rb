class AddReactionToNotify < ActiveRecord::Migration
  def self.up
    add_column :notifies, :reaction_id, :integer
  end

  def self.down
    remove_column :notifies, :reaction_id
  end
end
