class PatchesController < ApplicationController

  before_filter :authenticate_user!

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

private

  def title
    "#{repository.name} [#{repository.branch}]"
  end

  def repository
    @repository ||= Repository.new("/Users/developer/Desktop/#{params[:repository_id]}", params[:branch_id].to_s)
  end


  
end
