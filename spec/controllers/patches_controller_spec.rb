require 'spec_helper'

describe PatchesController do

  fixtures :users
  render_views

  before :each do
    @controller = PatchesController.new
    @controller.stubs(:repository).returns(Repository.new("test/fixtures/test.git/"))
  end


  describe "GET 'index'" do
    
    it "should not used by not authenticated user" do
      get :index
      assert_response :redirect
      assert_redirected_to new_user_session_path
    end

    it "should have an index page" do
      sign_in User.first
      get :index
  
      assert_response :success
      response.should render_template(["layouts/reviewer", "/patches/index"])
      
      assert_select "#repository_branch"
    end
  end
  
end
