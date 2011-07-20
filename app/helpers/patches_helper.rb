require 'digest/md5'

module PatchesHelper

  def parse (plain_diff)
    
    lines = []
    length = 0
    plus, minus = 0, 0
    content_is_coming = false
    
    plain_diff.to_s.split("\n").each do |line|
      if line =~ /^@@ (.*) @@$/
        
        patch_info = line.match(/^@@ \-(\d*),(\d*) \+(\d*),(\d*) @@$/)
        
        length = patch_info[2].to_i
        plus   = patch_info[3].to_i - 1
        minus  = patch_info[1].to_i - 1
        
        lines << [nil, nil, line]
        next
      end
      

        line_info = [nil, nil, nil]
        
        if line.match /^\+/
          plus += 1
          line_info[0] = plus
          line_info[2] = "+ " + line.match(/^\+(.*)/)[1]
        elsif line.match /^\-/
          minus += 1
          line_info[1] = minus
          line_info[2] = "- " + line.match(/^\-(.*)/)[1]
        else
          plus += 1
          minus += 1
          line_info[0] = plus
          line_info[1] = minus
          line_info[2] = " " + line
        end
        
        lines << line_info


    end
    return lines
  end

  def class_name(line, number_of_comments)
    cn = "" 
    
    cn += "minus " if line.minus? and not line.plus?
    cn += "plus "  if line.plus? and not line.minus?
    
    cn += "commented " if number_of_comments > 0
    return cn.strip
  end

  def format_line(line)
    line = h(line)
    line.gsub(/[ ]/, '&nbsp;')
  end

  def get_comments(comments, block, line)
    actual_comments = []
    i = 0
    
    comments.each do |comment|
      if comment.line == line and comment.block == block
        actual_comments << comment
      end
      i += 1
    end
    return actual_comments
  end
  
  def by_day(all)
    dates = []
    last_day = nil
    i = -1

    all.each do |patch|
      c = patch.date.strftime("%Y%m%d")
      if (c != last_day)
        i += 1
        last_day = c
      end
      dates[i] ||= Review::Day.new(patch.date)
      dates[i]  << patch
    end
    return dates
  end
  
  def avatar(email)
    email.downcase!
    "http://gravatar.com/avatar/" + Digest::MD5.hexdigest(email)
  end
end
