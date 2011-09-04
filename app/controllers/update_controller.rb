require 'lib/response.rb'

class UpdateController < ApplicationController

  before_filter :repository_must_be_defined
  before_filter :repository_must_exists

  def index
    begin
      fetch_origin
      update_references
      @response = Response.new :result => :success
    rescue Exception => e
      @response = Response.new :result => :error, :message => e.to_s  
    end
    render_response
  end
  
protected

  def repository_must_be_defined
    unless params[:repository_id]
      redirect_to "/"  
    end
  end

  def repository_must_exists
    unless File.directory?("#{repository}/.git")
      @response = Response.new({:result => :error, :message => "Git directory is missing"})
      render_response
    end
  end

  def fetch_origin
    ::Grit::Git.git_timeout = 60
    plain_repository.fetch
  end

  def update_references
    Repository.new(repository).branches(:show => :only_names).each do |branch|
      plain_repository.update_ref({}, "refs/heads/#{branch}", "origin/#{branch}")
    end
  end

  def plain_repository
    @plain_repository ||= ::Grit::Git.new("#{repository}/.git")
  end
  
  def repository
    "#{CONFIG["repository_path"]}/#{params[:repository_id]}"
  end

  def render_response
    respond_to do |format|
      format.html { render :index }
      format.xml  { render :xml => @response.to_xml }
      format.json { render :json => @response.to_json }
    end
  end
  
end
