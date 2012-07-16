class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :comment

  PATCH = 1
  COMMENT = 2
  ACCEPT = 3
  DECLINED = 4

  READ = 1
  UNREAD = 2

  validates_presence_of :repository_id
  validates_presence_of :status
  validates_presence_of :topic
end
