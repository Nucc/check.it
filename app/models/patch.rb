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
  
  attr :author_name
  attr :author_email
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
  
  def author_name
    @etalon.author.name
  end
  
  def author_email
    @etalon.author.email
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