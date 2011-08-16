class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_title
  
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
  
  def should_have_branch
    params[:branch_id] ||= session[:branch_id]
    redirect_to :controller => :repositories if params[:branch_id].nil?
  end
end
