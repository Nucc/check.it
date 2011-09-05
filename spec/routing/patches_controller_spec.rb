require 'spec_helper'

describe PatchesController do
  
  it "/patches => /repositories"
  
  it "/repositories/../patches" do
    { :get => "/repositories/test.git/patches" }.
      should route_to(:controller => "patches",
                      :action => "index",
                      :repository_id => "test.git")
  end
  
  it "/repositories/../branches/../patches" do
    { :get => "/repositories/test.git/branches/test.branch/patches" }.
      should route_to(:controller => "patches",
                      :action => "index",
                      :repository_id => "test.git",
                      :branch_id => "test.branch")
  end
  
  it "/repositories/foo should route to /repositories/foo/patches" do
    { :get => "/repositories/test.git"}.
      should route_to(:controller => "patches",
                      :action => "index",
                      :repository_id => "test.git")
  end
  
end
 