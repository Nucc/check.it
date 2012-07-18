class NotificationMailer < ActionMailer::Base
  default :from => CONFIG["sender_email"]

  def send_unread_notifications (user)
    @user = user
    mail :to => @user.email,
         :subject => "[Review] You have unread review notifications"
  end
end
