class Comment < ActiveRecord::Base
  belongs_to :commit
  
  attr_accessor :commit_sha
end
