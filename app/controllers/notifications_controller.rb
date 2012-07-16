class NotificationsController < ApplicationController

 layout "reviewer"

  def index
    @all_notification = Notification.find_all_by_user_id(@user.id, :order=> "created_at desc")
  end

  def show
    notification = Notification.find(params[:id])

    commit    = notification.comment.commit
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
      notification = comment.notification

      # only the user can change the read flag!
      if notification and notification.user_id == @user.id
        notification.status = Notification::READ
        notification.save!
      end
    end

    redirect_to repository_patch_url(@repo, @patch)
  end

end
