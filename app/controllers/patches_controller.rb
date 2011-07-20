class PatchesController < ApplicationController

  before_filter :authenticate_user!

  def repository
    Repository.new("/Users/developer/Desktop/have2do.it")
  end

  def index
    @pager = ::Paginator.new(repository.count, 30) do |offset, per_page|
      repository.patches(per_page, offset)
    end
    @patches = @pager.page(params[:page])
    @repository = repository
  end
  
  def show
    @patch = repository.patch(params[:id])
    commit = Commit.find_by_sha(params[:id])
    if commit
      @comments = commit.comments
    else
      @comments = []
    end
  end
  
end
