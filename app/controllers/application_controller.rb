class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_title
  before_filter :set_user
  before_filter :set_notify_messages
  
  def set_title
    @page_title = title
  end
  
  def title
    @page_title || ""
  end


  def should_have_repository
    params[:repository_id] ||= session[:repository_id]
    redirect_to :controller => :repositories if params[:repository_id].nil?
  end
  
  def should_have_patchid
    params[:patch_id] ||= session[:patch_id]
    redirect_to :controller => :repositories if params[:patch_id].nil?
  end

  def set_user
    @user = current_user
  end
  
  def set_notify_messages
    return unless current_user
    @notifies = Notify.where(["user_id = ? and status = ?", current_user.id, Notify::UNREAD]).all
  end

end
