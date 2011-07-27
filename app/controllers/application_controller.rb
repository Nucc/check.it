class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_title
  
  def set_title
    @page_title = title
  end
  
  def title
    @page_title || ""
  end
end
