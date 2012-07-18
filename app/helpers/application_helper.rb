module ApplicationHelper

  def change_endlines(text)
    sanitize(text.gsub(/\n/, '<br />'), :tags => %w(br))
  end

  def format_date(date)
    return date.to_s
  end

  def human_time(date)
    date.strftime("%Y %b %d, %H:%M")
  end



  def format_patch(patch)
    link_to(patch, repository_patch_url(patch.repository, patch))
  end

  def format_notification(notification)
    name = notification.comment.user.username

    message = ""
    if (notification.topic == Notification::PATCH)
      message = "commented your patch"
    elsif (notification.topic == Notification::COMMENT )
      message = "also commented on your reply"
    elsif (notification.topic == Notification::ACCEPTED )
      message = "accepted your patch"
    elsif (notification.topic == Notification::DECLINED )
      message = "declined your patch"
    end

    return link_to "#{name} #{message}", notification_url(notification)
  end

  def order_by_date(entries, ordering_attribute)
    elements = {}
    read_key = nil
    key = nil

    entries.each do |entry|
      read_key = entry.send ordering_attribute.to_sym
      if read_key != key
        key = read_key
        elements[key] = []
      end
      elements[key] << entry
    end

    return elements
  end

  def paginator(entries, pager, url_method, *args)
    lines = ""
    lines << "<div id=\"paginator\">"
    lines << link_to("<<< ", self.send(url_method, args.flatten!, :page => entries.prev.number)) if entries.prev

    pager.each do |page|
      if page.number != entries.number
        lines << " <span>"
        lines << link_to(page.number, self.send(url_method, args.flatten!, :page => page.number))
        lines << "</span> "
      else
         lines << "<span class=\"current\">"
         lines << entries.number.to_s
         lines << "</span> "
      end
    end
    lines << link_to(">>>", self.send(url_method, args.flatten!, :page => entries.next.number)) if entries.next
    lines << "</div>"
    lines.html_safe
  end

end
