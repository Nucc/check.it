class Commit < ActiveRecord::Base

  belongs_to :commit_diff
  belongs_to :branch
  validate :sha, :uniqueness => true
  
  def comments
    commit_diff.comments
  end
  
  def patch=(patch)
    self.sha = patch.sha
  end

  def patch
    Repository.all.each do |repo|
      patch = repo.patch(self.sha)
      return patch if patch
    end
  end

end
