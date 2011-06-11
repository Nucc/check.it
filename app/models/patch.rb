require 'git'

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

class Patch 
  
  include ActiveModel::AttributeMethods
  extend ActiveModel::Naming
  
  def initialize(patch)
    if patch.respond_to?(:String)
      @patch = Patch.find(patch)
    else
      @patch = patch
    end
  end
    
  def self.working_area
    working_area ||= Git.open("/Users/developer/Desktop/have2do.it")
  end
  
  def self.all
    patches = []
    working_area.log.each do |log|
      patches << Patch.new(log)
    end
    return patches
  end  
  
  def self.find(id)
    Patch.new( working_area.gcommit(id) )
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
    @patch.sha
  end

  def parent
    Patch.new(@patch.parent)
  end

  def tags
    return @tags if @tags
    
    @tags = []
    Patch.working_area.tags.each do |tag|
      @tags << tag if tag.sha == @patch.sha
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
