class Commit < ActiveRecord::Base

  belongs_to :commit_diff
  validate :sha, :uniqueness => true
  
  def comments
    commit_diff.comments
  end
  
  def patch=(patch)
    self.sha = patch.sha
  end
end
