class CommentShouldRefersToCommentDiff < ActiveRecord::Migration
  def self.up
    rename_column :comments, :commit_id, :commit_diff_id    
  end

  def self.down
    rename_column :comments, :commit_diff_id, :commit_id
  end
end
