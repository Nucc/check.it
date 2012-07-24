require 'lib/response.rb'

class UpdateController < ApplicationController

  before_filter :repository_must_be_defined
  before_filter :repository_must_exists
  before_filter :check_full_index

  def index
    begin
      fetch_origin
      update_references
      index_patches
      @response = Response.new :result => :success
    rescue Exception => e
      @response = Response.new :result => :error, :message => e.to_s
    end

    invalidate_cache_entries
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

        if branch != "HEAD"
          plain_repository.update_ref({}, "refs/heads/#{branch}", "origin/#{branch}")
        end
      end
    end
  end

  def index_patches
    repo = Repository.by_name(params[:repository_id])
    repo.branches.each do |branch|
      branch_model = Branch.find_or_create_by_repository_and_name(repo.name, branch.repository.branch)
      add_the_new_patches(branch, branch_model)
    end
  end

  def add_the_new_patches(head, branch)
    create_commit(head, branch)

    head.parents.each do |parent|
      add_the_new_patches(parent, branch)
    end

    found_unknown_entry

  rescue NoPatch
    return

  rescue ActiveRecord::RecordNotUnique
    return unless @need_full_index
    head.parents.each do |parent|
      add_the_new_patches(parent, branch)
    end
  end

  def create_commit(patch, branch)
    commit = Commit.new
    commit.patch = patch
    commit.commit_diff = CommitDiff.create_or_find(patch)
    commit.created_at = patch.date
    commit.branch = branch
    commit.save!
  end

  def plain_repository
    @plain_repository ||= ::Grit::Git.new("#{repository}/.git")
  end

  def repository
    "#{CONFIG["repository_path"]}/#{params[:repository_id]}"
  end

  def render_response
    @back_url = params[:back_url]
    return redirect_to @back_url if params[:redirect]

    respond_to do |format|
      format.html { render :index }
      format.xml  { render :xml => @response.to_xml }
      format.json { render :json => @response.to_json }
    end
  end

  def check_full_index
    @need_full_index = params[:full_index]
  end

private

  def found_unknown_entry
    @expired = true
  end

  def invalidate_cache_entries
    expire_repository(params[:repository_id]) if @expired
  end

end
