class PatchesController < ApplicationController

  layout "reviewer"

  before_filter :authenticate_user!
  before_filter :use_patch_id_instead_of_id, :only => [:show]
  before_filter :should_have_repository, :only => [:show]
  before_filter :should_have_branch, :only => [:show]
  before_filter :should_have_patchid, :only => [:show]

  def index
    @pager = ::Paginator.new(repository.count, 30) do |offset, per_page|
      repository.patches(per_page, offset)
    end
    @patches = @pager.page(params[:page])
    @repository = repository
    session[:repository_id] = params[:repository_id]
    session[:branch_id] = params[:branch_id] || "master"
  end

  def show
    @patch = repository.patch(params[:id])
    @reaction = Reaction.new
    session[:patch_id] = params[:id]
    commit_diff = CommitDiff.find_by_sha(@patch.diff_sha)

    set_comments_and_reactions_using commit_diff
  end

private

  def title
    "#{repository.name}"
  end

  def repository
    @repository ||= Repository.new("#{CONFIG["repository_path"]}/#{params[:repository_id]}", branch)
  end

  def branch
    (params[:branch_id] || "master").to_s
  end

  def use_patch_id_instead_of_id
    # FIXME: It isn't so nice, so try to find a solution to bind :id to :patch_id somehow
    params[:patch_id] = params[:id]
  end

  def set_comments_and_reactions_using (commit_diff)
    if commit_diff
      @reaction.commit_diff_id = commit_diff.id
      @comments  = commit_diff.comments
      @reactions = commit_diff.reactions
    else
      @comments  = []
      @reactions = []
    end
  end

end
