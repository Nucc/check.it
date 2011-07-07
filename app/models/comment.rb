class Comment < ActiveRecord::Base
  belongs_to :commit
  belongs_to :user
  
  attr_accessor :commit_sha
end
