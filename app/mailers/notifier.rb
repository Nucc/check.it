class Notifier < ActionMailer::Base
  default :from => "review@balabit.hu"

  def notify_patch_got_a_message (recipents)
    recipents.each do |recipent|
      mail :to => recipent,
           :subject => "[Review] New comment has added"
    end
  end

end
