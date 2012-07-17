class NotificationsController < ApplicationController

  layout "reviewer"

  PER_PAGE = 100

  def index
    count = Notification.find_all_by_user_id(@user.id).count
    @pager = ::Paginator.new(count, PER_PAGE) do |offset, per_page|
      Notification.order("created_at DESC").by_user(@user.id).offset(offset).limit(per_page)
    end
    @all_notification = @pager.page(params[:page])
  end

  def show
    notification = Notification.find(params[:id])

    commit = notification.comment.commit
    return redirect_to("/") unless commit

    set_read_all_same_notifications_of (commit)
    jump_to (commit)
  end


private

  def set_read_all_same_notifications_of (commit)
    commit.comments.each do |comment|
      notification = comment.notification

      # only the user can change the read flag!
      if notification and notification.user_id == @user.id
        notification.status = Notification::READ
        notification.save!
      end
    end
  end

  def jump_to (commit)
    repository, patch = nil

    Repository.all.each do |repo|
      repository  = repo
      patch = repo.patch(commit.sha)
      break if patch
    end

    if (repository and patch)
      redirect_to repository_patch_url(repository, patch)
    else
      redirect_to "/"
    end
  end
end
