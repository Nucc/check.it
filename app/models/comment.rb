class Comment < ActiveRecord::Base
  belongs_to :commit_diff
  belongs_to :user
  has_one    :notify
  
  attr_accessor :commit_sha
  
  def commit
    commit_diff.commits[0]
  end
  
end
