module ApplicationHelper

  def change_endlines(text)
    sanitize(text.gsub(/\n/, '<br />'), :tags => %w(br))
  end

  def format_date(date)
    
    return date.to_s
    
    if date > Time.now - 7.days
      time_ago_in_words(date) + " ago"
    else
      date.strftime("%b %d, %Y")
    end
  end

  def format_patch(patch)
    link_to(patch, repository_patch_url(patch.repository, patch))
  end

  def format_notify(notify)
    name = notify.comment.user.username
    
    message = ""
    if (notify.topic == Notify::PATCH)
      message = "commented your patch"
    elsif (notify.topic == Notify::COMMENT )
      message = "also commented on your reply"
    elsif (notify.topic == Notify::ACCEPTED )
      message = "accepted your patch"
    elsif (notify.topic == Notify::DECLINED )
      message = "declined your patch"
    end
    
    return link_to "#{name} #{message}", notify_url(notify)
  end
end
