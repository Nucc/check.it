class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :comment

  PATCH = 1
  COMMENT = 2
  ACCEPT = 3
  DECLINED = 4

  READ = 1
  UNREAD = 2

  scope :by_user, lambda {|user_id| {:conditions => {:user_id => user_id}}}

  scope :status, lambda {|status| {:conditions => {:status => status}}}

  scope :unread, where(:status => UNREAD)

  scope :grouped_by_user, select("user_id").group("user_id")

  validates_presence_of :repository_id
  validates_presence_of :status
  validates_presence_of :topic

  def created
    self.created_at.to_s.split(" ")[0]
  end

end
