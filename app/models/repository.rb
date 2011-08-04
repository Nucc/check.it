require "grit.rb"

# Represents a git repository
# Currently it's using Grit
class Repository
  
  attr :patches
  
  def initialize(url, branch = nil)
    @url = url
    @grit_object = Grit::Repo.new(url)
    @name = url.split("/")[-1]
    @branch = branch
  end
  
  def branch
    @branch or "master"
  end
  
  def branch_path
    repository_branch_path(self, branch)
  end
  
  def name
    @name
  end
  
  def patches(number = 30, index = 0)
    temp = []
    # using commits_since because I didn't find better solution
    # to iterate over the commits
    @grit_object.commits(branch, number, index).each do |commit|
      temp << Patch.new(self, commit)
    end
    return temp
  end
  
  def branches
    branches = []
    @grit_object.branches.each do |b|
      branches << Patch.new(Repository.new(@url, b.name), b.commit)
    end
    return branches
  end
  
  def tags
    @grit_object.tags
  end
  
  def patch(id)
    Patch.new( self, @grit_object.commit(id) )
  end
  
  def count
    @grit_object.commit_count(branch)
  end
  
  def to_s
    @name
  end
end