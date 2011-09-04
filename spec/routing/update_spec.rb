require 'spec_helper'

describe UpdateController do
  
  it "/update/test.git" do
    { :get => "/update/test.git" }.
      should route_to(:controller => "update",
                      :action => "index",
                      :repository_id => "test.git")
  end

end
