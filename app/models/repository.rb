require "grit.rb"

# Represents a git repository
# Currently it's using Grit
class Repository

  attr :patches

  def self.by_name(name)
    repository_path = CONFIG["repository_path"]
    return Repository.new("#{repository_path}/#{name}")
  end

  def self.all
    repositories = []
    repository_path = CONFIG["repository_path"]
    Dir.foreach(repository_path).each do |dir|
      next if dir == ".." or dir == "."
      begin
        repositories << Repository.new("#{repository_path}/#{dir}")
      rescue Grit::InvalidGitRepositoryError => e
      end
    end
    repositories
  end

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

  def description

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

  def branches(args = {:show => :patches})
    branches = []
    @grit_object.branches.each do |b|
      case args[:show]
        when :only_names
          branches << b.name
        else
          branches << Patch.new(Repository.new(@url, b.name), b.commit)
      end
    end
    return branches
  end

  def tags
    @tags ||= @grit_object.tags
    @tags
  end

  def patch(id)
    @obj ||= @grit_object.commit(id)
    return (@obj && Patch.new( self, @obj ))
  end

  def count
    @commit_count ||= @grit_object.commit_count(branch)
    @commit_count
  end

  def to_s
    @name
  end
end
