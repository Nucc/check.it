require 'lib/response.rb'

class UpdateController < ApplicationController

  before_filter :repository_must_be_defined
  before_filter :repository_must_exists

  def index
    begin
      fetch_origin
      update_references
      index_patches
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
    ::Grit::Git.git_timeout = 600
    plain_repository.fetch
    plain_repository.remote({}, "prune", "origin")
  end

  def update_references
    
    # Remove all the references first
    Repository.new(repository).branches(:show => :only_names).each do |branch|
      plain_repository.update_ref({"d" => true}, "refs/heads/#{branch}") unless branch == "master"
    end
    
    # Set the branches using the origin remote 
    Grit::Repo.new(repository).remotes.each do |remote|
      if remote.name.match(/^origin/)
        branch = remote.name.split("origin/")[1]
        
        if not branch.include?("/") and branch != "HEAD"
          plain_repository.update_ref({}, "refs/heads/#{branch}", "origin/#{branch}")
        end
      end
    end
  end
  
  def index_patches
    Repository.all.each do |repo|
      repo.branches.each do |branch|
        branch_model = Branch.find_or_create_by_repository_and_name(repo.name, branch.repository.branch)
        add_the_new_patches(branch, branch_model)
      end
    end
  end
  
  def add_the_new_patches(head, branch)
    commit = Commit.new
    commit.patch = head
    commit.commit_diff = CommitDiff.create_or_find(head)
    commit.created_at = head.date
    commit.branch = branch
    commit.save!
    return add_the_new_patches(head.parent, branch)
  rescue NoPatch, ActiveRecord::RecordNotUnique
    return
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
