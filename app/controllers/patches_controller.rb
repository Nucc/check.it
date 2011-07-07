class PatchesController < ApplicationController

  before_filter :authenticate_user!

  def index
    @days = Patch.by_day
  end
  
  def show
    @patch = Patch.find params[:id]
    
    commit = Commit.find_by_sha(params[:id])
    if commit
      @comments = commit.comments
    else
      @comments = []
    end
  end
  
end
