class PatchesController < ApplicationController

  before_filter :authenticate_user!

  def index
    repository = Repository.new("/Users/developer/Desktop/have2do.it")
    params[:page] ||= 1
    
    @patches = repository.patches(30, (params[:page].to_i - 1) * 30)
  end
  
  def show
    
    repository = Repository.new("/Users/developer/Desktop/have2do.it")
    
    @patch = repository.patch(params[:id])
    
    commit = Commit.find_by_sha(params[:id])
    if commit
      @comments = commit.comments
    else
      @comments = []
    end
  end
  
end
