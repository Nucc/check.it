require "grit.rb"

# Represents a git repository
# Currently it's using Grit
class Repository
  
  attr :patches
  
  def initialize(url)
    @grit_object = Grit::Repo.new(url)
  end
  
  def patches(number = 30, index = 0)
    temp = []
    # using commits_since because I didn't find better solution
    # to iterate over the commits
    @grit_object.commits("master", number, index).each do |commit|
      p commit
      temp << Patch.new(commit)
    end
    return temp
  end
  
  def patch(id)
    Patch.new( @grit_object.commit(id) )
  end
end