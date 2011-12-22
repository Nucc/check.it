class RepositoriesController < ApplicationController

  before_filter :authenticate_user!

  def index
    @repositories = repositories
  end

protected
  
  def repositories
    repositories    = []
    repository_path = CONFIG["repository_path"]
    Dir.foreach(repository_path).each do |dir|
      begin
        repositories << Repository.new("#{repository_path}/#{dir}")
      rescue Grit::InvalidGitRepositoryError
      end
    end
    return repositories
  end

end