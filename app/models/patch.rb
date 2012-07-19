require 'grit'
require 'digest/sha1'

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

  def parents
    parents = []
    @etalon.parents.each do |parent|
      parents << Patch.new(repository, parent)
    end
    parents
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
    return commit.comments if commit
    return CommitDiff.find_by_sha(self.diff_sha).comments
  rescue
    []
  end

  def reactions
    return commit.reactions if commit
    return CommitDiff.find_by_sha(self.diff_sha).reactions
  rescue
    []
  end

  def diff

    diff = String.new
    blocks = []

    # We should use the d self
    @etalon.diffs.each do |hunk|

      block  = Block.new
      block.number = blocks.length
      block.filename = hunk.a_path
      hunk.diff.lines.each do |line|
        block.parse(line)
      end

      blocks << block
    end

    return blocks
  end

  #
  # Representations
  #
  def to_s
    sha
  end

  def diff_sha
    return @diff_sha if @diff_sha

    str = String.new
    @etalon.diffs.each do |block|
      str += block.diff.to_s
    end

    @diff_sha = Digest::SHA1.hexdigest(str)
  end

protected

  def commit
    @commit ||= Commit.find_by_sha(sha)
  end

end
