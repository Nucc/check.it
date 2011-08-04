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

end
