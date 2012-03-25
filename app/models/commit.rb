class Commit < ActiveRecord::Base

  belongs_to :commit_diff
  belongs_to :branch
  validate   :sha, :uniqueness => true
  has_many   :comments,  :through => :commit_diff
  has_many   :reactions, :through => :commit_diff
    
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
