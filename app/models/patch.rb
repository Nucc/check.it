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
  attr :repository
  
  # Currently we use Grit for git representation.
  # Later if we change it to another git ruby implementation, 
  # we should modify only this class
  # +patch = Grit patch
  def initialize(repository, patch)
    @etalon = patch
    @repository = repository
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
    return Patch.new(repository, @etalon.parents[0]) unless @etalon.parents[0].nil?
    raise NoPatch
  end
  
  def tree
    @etalon.tree.id
  end
  
  def tags
    tags = []
    @repository.tags.each do |tag|
      tags << tag.name if tag.commit.sha == @etalon.id
    end
    tags
  end
  
  def comments
    comments = commit.comments if commit
    comments || []
  end
  
  def diff
    diff = String.new
    
    return [] if parent.nil?
    
    # We should use the d self
    @etalon.repo.diff(parent.sha, sha).each do |d|
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
  
protected

  def commit
    @commit ||= Commit.find_by_sha(sha)
  end
  
end