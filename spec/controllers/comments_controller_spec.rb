require 'spec_helper'

describe CommentsController do
  # Replace this with your real tests.
  
  it "should not used by not authenticated user" do
    get :new
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end
  
  it "GET 'index'"
  
  describe "GET 'new'" do

    fixtures :users

    before :each do
      sign_in User.first
    end
    
    it "should have repository and patch id" do
      session[:repository_id] = "1"
      session[:branch_id] = "2"
      get :new
      assert_response :success
    end
    
    it "should redirect to sign in page when repository and patch id is missing" do
      get :new
      assert_redirected_to repositories_path
    end

    it "should redirect to repositories/index if branch id is missing" do
      session[:repository_id] = "1"
      get :new
      assert_redirected_to repositories_path
    end
  
    it "should redirect to repositories/index if repository id is missing" do
      session[:branch_id] = "1"
      get :new
      assert_redirected_to repositories_path
    end
    
    it "should get the repository id from url" do
      session[:branch_id] = "2"
      get :new, :repository_id => "1"
      assert_response :success
    end
    
    it "should get the branch id from url" do
      session[:repository_id] = "2"
      get :new, :branch_id => "1"
      assert_response :success      
    end    
  end
end
