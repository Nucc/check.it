class NotifiesController < ApplicationController

  def index
  end
  
  def show
    notify = Notify.find(params[:id])
        
    
    commit    = notify.comment.commit
    return redirect_to("/") unless commit
    
    patch_sha = commit.sha
    
    @patch = nil
    @repo  = nil
    
    Repository.all.each do |repo|
      @repo  = repo
      @patch = repo.patch(patch_sha)
      break if @patch
    end
    
    commit.comments.each do |comment|
      notify = comment.notify
      
      # only the user can change the read flag!
      if notify and notify.user_id == @user.id
        notify.status = Notify::READ
        notify.save!
      end
    end
    
    redirect_to repository_patch_url(@repo, @patch)
  end

end
