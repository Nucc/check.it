class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_title
  before_filter :set_user
  before_filter :set_notify_messages

protected

  def set_title
    @page_title = title
  end

  def title
    @page_title || ""
  end


  def should_have_repository
    set_environment(:repository_id)
  end

  def should_have_patchid
    set_environment(:patch_id)
  end

  def should_have_branch
    session[:branch_id] ||= "master"
    set_environment(:branch_id)
  end

  def set_user
    @user = current_user
  end

  def set_notify_messages
    return unless current_user
    @notifications = Notification.by_user(current_user.id).status(Notification::UNREAD).all
  end

private

  def set_environment(key)
    params[key] = session[key] unless params[key]
    session[key] = params[key]
    redirect_to "/" if params[key].nil?
  end
end
