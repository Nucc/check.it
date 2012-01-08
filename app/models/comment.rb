class Comment < ActiveRecord::Base
  belongs_to :commit
  belongs_to :user
  has_one    :notify
  
  attr_accessor :commit_sha
end
