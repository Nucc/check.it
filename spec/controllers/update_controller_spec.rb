require 'spec_helper'

describe UpdateController do

  describe "GET 'index'" do
    it "without repository should redirect to '/'" do
      get 'index'
      response.should redirect_to("/")
    end
  
    it "should be success when repository is exists" do
      get 'index', :repository_id => "update_test.git"
      response.should be_success
    end
    
    describe "view" do
      render_views
      
      it "should have git repository is missing text when repository is missing" do
        get 'index', :repository_id => "update_testa.git", :format => :xml
        response.should have_tag("result", "error")
        response.should have_tag("message","Git directory is missing")
        
        get 'index', :repository_id => "update_testa.git", :format => :json
        response.body.should == "{\"response\":{\"result\":\"error\",\"message\":\"Git directory is missing\"}}"
        
        get 'index', :repository_id => "update_testa.git"
        response.body.should match("Git directory is missing")
      end
    end
  end  

end
