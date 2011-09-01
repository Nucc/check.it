require "spec_helper"
require "utils"

describe "Update the repositories", :type => :request do
  
  before do
    pending("request")
  end
  
  describe "for calling an URL" do
    it "that looks as /update/test.git, where test.git the repository name" do
    end
  end

  describe "with /update/test.git" do

    before :each do
      move_git_reference :test_update_repository_branch1, :f7d10b1380081fa08d96191638606d8d235e24e2
      move_git_reference :test_update_repository_branch2, :debf1ef841a1d0603cb0d4153e34b9b6af4020b2
    end

    it "should reset --hard the test_update_repository_branch1 and test_update_repository_branch2 in test.git" do
      # just check move_git_reference
      branch_reference(:test_update_repository_branch1).should == "f7d10b1380081fa08d96191638606d8d235e24e2"
      branch_reference(:test_update_repository_branch2).should == "debf1ef841a1d0603cb0d4153e34b9b6af4020b2"
    end

    it "should fetch and reset --hard to the origin remote" do
      fetch :origin
      get "/update/test.git"
      branch_reference("origin/test_update_repository_branch1").should == branch_reference("test_update_repository_branch1")
      branch_reference("origin/test_update_repository_branch2").should == branch_reference("test_update_repository_branch2")
    end
    
    it "should insert the commits to the database" do
      get "/update/test.git"
      branch1 = branch_reference("origin/test_update_repository_branch1")
      branch2 = branch_reference("origin/test_update_repository_branch2")
      Commit.find_by_sha(branch1).should_not be_nil
      Commit.find_by_sha(branch2).should_not be_nil
    end

    after :all do
      move_git_reference :test_update_repository_branch1, "origin/test_update_repository_branch1"
      move_git_reference :test_update_repository_branch2, "origin/test_update_repository_branch2"
    end
  end
  

end