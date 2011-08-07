require 'test_helper'

class PatchesControllerTest < ActionController::TestCase

  setup do
    @controller = PatchesController.new
    @controller.stubs(:repository).returns(Repository.new("test/fixtures/test.git/"))
  end

  should "not used by not authenticated user" do
    get :index
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  should "have an index page" do
    sign_in User.first
    get :index
  
    #index should have branches
    assert_select "#repository_branch"
  end

  should "show" do
    assert false
  end
end
