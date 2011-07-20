require 'grit'

module Review
  class Day
    attr_reader :day
    attr_reader :patches
  
    def initialize(day)
      @day = day
      @patches = []
    end
  
    def <<(element)
      @patches << element
    end
  end
  
end  

class NoPatch < Exception
end

class Patch
  
  include ActiveModel::AttributeMethods
  extend  ActiveModel::Naming
  
  attr :author
  attr :sha
  attr :date
  attr :message
  attr :parent
  attr :tree
  attr :tags
  
  # Currently we use Grit for git representation.
  # Later if we change to other git ruby edition, 
  # we should modify only this class
  # +patch = Grit patch
  def initialize(patch)
    @etalon = patch
  end
  
  
  #
  # Getter methods
  #  
  # Returns the sha identifier of the commit
  def sha
    @etalon.sha
  end
  
  def author
    "%s <%s>" % [@etalon.author.name, @etalon.author.email]
  end
  
  def date
    @etalon.authored_date
  end
   
  def message
    @etalon.message
  end
  
  def parent
    return Patch.new(@etalon.parents[0]) unless @etalon.parents[0].nil?
    raise NoPatch
  end
  
  def tree
    @etalon.tree.id
  end
  
  def tags
    tags = []
    @etalon.repo.tags.each do |tag|
      p tag.commit.id
      p @etalon.id
      p "=="
      tags << tag.name if tag.commit.id == @etalon.id
    end
    tags
  end
  
  def comments
    commit = Commit.find_by_sha(sha)
    comments = []
    comments = commit.comments if commit
    return comments
  end
  
  def diff
    diff = String.new
    
    @etalon.repo.diff(sha, parent.sha).each do |d|
      diff += d.diff + "\n"
    end
    
    blocks = []
    
    block  = Block.new
    block.number = blocks.length
    diff.lines.each do |line|
      if block.parse(line)
        next
      else
        blocks << block
        block = Block.new
        block.number = blocks.length
      end
    end
    blocks << block
    return blocks
  end
  
  #
  # Representations
  #
  def to_s
    sha
  end
  
  
  
end


=begin
class Patch 
  
  include ActiveModel::AttributeMethods
  extend  ActiveModel::Naming
  
  def initialize(patch)
    if patch.respond_to?(:String)
      @patch = Patch.find(patch)
    else
      @patch = patch
    end
  end
    
  def self.working_area
    working_area ||= Grit::Repo.new("/Users/developer/Desktop/have2do.it")
  end
  
  def self.all
    patches = []
    working_area.commits.each do |log|
      patches << Patch.new(log)
    end
    return patches
  end  
  
  def self.find(id)
    #Patch.new( Grit::Commit::find_all(working_area, id) )
  end

  def self.by_day
    all = self.all
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

  def to_s
    @patch.id
  end

  def message
    @patch.to_s
    #@patch.messages.join("\n")
  end

  def parent
    Patch.new(@patch.parents[0])
  end

  def tags
    return @tags if @tags
    
    @tags = []
    Patch.working_area.tags.each do |tag|
      @tags << tag if tag.id == @patch.sha
    end
    return @tags
  end

  def diff
    id = @patch.to_s
    diff = StringIO.new(Patch.working_area.diff("#{id}^", "#{id}").patch)
    
    blocks = []
    
    block  = Block.new
    block.number = blocks.length
    diff.lines.each do |line|
      if block.parse(line)
        next
      else
        blocks << block
        block = Block.new
        block.number = blocks.length
      end
    end
    blocks << block
    return blocks
  end
  
  def comments
    commit = Commit.find_by_sha(@patch.sha)
    comments = []
    comments = commit.comments if commit
    return comments
  end
  
  def method_missing(method)
    @patch.send(method.to_sym)
  end
  
end
=end