require "grit.rb"

# Represents a git repository
# Currently it's using Grit
class Repository
  
  attr :patches
  
  
  def initialize(url, branch)
    @grit_object = Grit::Repo.new(url)
    @name = url.split("/")[-1]
    @branch = branch
  end
  
  def branch
    @branch or "master"
  end
  
  def name
    @name.camelcase
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