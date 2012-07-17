class CommitDiff < ActiveRecord::Base

  has_many :commits
  has_many :comments
  has_many :reactions
  validate :sha, :uniqueness => true


  def self.create_or_find(patch)
    diff_sha = patch.diff_sha
    commit_diff = CommitDiff.find_by_sha(diff_sha)

    unless commit_diff
      commit_diff = CommitDiff.new
      commit_diff.sha = diff_sha
      commit_diff.save!
    end

    return commit_diff
  end

end
