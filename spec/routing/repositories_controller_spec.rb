require 'spec_helper'

describe RepositoriesController do
  
  it "/" do
    { :get => "/" }.
      should route_to(:controller => "repositories",
                      :action => "index")
  end

end
