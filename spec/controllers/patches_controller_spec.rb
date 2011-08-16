require 'spec_helper'

describe PatchesController do

  fixtures :users

  before :each do
    @controller = PatchesController.new
    @controller.stubs(:repository).returns(Repository.new("test/fixtures/test.git/"))
  end


  describe "index" do
    
    render_views
    
    it "should not used by not authenticated user" do
      get :index
      assert_response :redirect
      assert_redirected_to new_user_session_path
    end

    it "should have an index page" do
      sign_in User.first
      get :index, {:repository_id => "repo_id"}
  
      assert_response :success
      response.should render_template(["layouts/reviewer", "/patches/index"])
      
      assert_select "#branch_id"
    end
    
    it "should set the repository id in session" do
      sign_in User.first
      get :index, {:repository_id => "repo_id"}
      session[:repository_id].should_not be_nil
    end
  end

  describe "show" do
    before :each do
      sign_in User.first
    end
        
    it "should store the commit id in session" do
      session[:repository_id] = ""
      get :show, {:id => "b21cd637c629e8a5e574ce038889d122eed18f58"}
      session[:patch_id].should == "b21cd637c629e8a5e574ce038889d122eed18f58"
    end
  end
end
