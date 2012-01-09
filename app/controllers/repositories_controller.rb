class RepositoriesController < ApplicationController

  layout "reviewer"

  before_filter :authenticate_user!

  def index
    @repositories = Repository.all
  end

protected
  
  def title
    "Repositories and branches"
  end

end
