class Commit < ActiveRecord::Base
  has_many :comments
end
