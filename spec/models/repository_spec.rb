require 'spec_helper'

describe Repository do

  subject { Repository.new("test/fixtures/test.git") }

  describe :commits do
    it "should be present some" do
      assert_equal(subject.patches.length, 3)
    end
  
    it "should be exactly 2" do
      assert_equal(subject.patches(2).length, 2)
    end
  end

  describe :patch do
    it "should find commit" do
      patch = subject.patch("f7d10b1380081fa08d96191638606d8d235e24e2")
      assert_not_nil(patch)
    end
  
    it "should return nil when patch doesn't not exist" do
      patch = subject.patch("aabbccddeeff")
      assert_nil(patch)
    end
  end

  describe :branch do
    
    it "should be master by default" do
      subject.branch.should == "master"
    end
    
    it "can be changed" do
      repository = Repository.new("test/fixtures/test.git", "test")
      repository.branch.should == "test"
    end
    
    it "should be asked" do
      branches = ["master"]
      subject.branches.each do |ref|
        assert(branches.include?(ref.repository.branch))
      end
    end
    
  end

end
