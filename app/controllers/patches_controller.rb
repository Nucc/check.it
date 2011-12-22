class PatchesController < ApplicationController

  layout "reviewer"

  before_filter :authenticate_user!
  before_filter :should_have_repository, :only => [:show]

  def index
    @pager = ::Paginator.new(repository.count, 30) do |offset, per_page|
      repository.patches(per_page, offset)
    end
    @patches = @pager.page(params[:page])
    @repository = repository
    session[:repository_id] = params[:repository_id]
    session[:branch_id] = params[:branch_id]
  end
  
  def show    
    @patch = repository.patch(params[:id])
    commit = Commit.find_by_sha(params[:id])
    if commit
      @comments = commit.comments
    else
      @comments = []
    end
    session[:patch_id] = params[:id]
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
end
