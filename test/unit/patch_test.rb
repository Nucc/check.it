require 'test_helper'
require 'mocha'

class PatchTest < ActiveSupport::TestCase
  
  setup do
    @repository = Object.new

    # Use the Grit object, because good to know if its interface changes
    @orig_patch = Grit::Commit.new( "12", "24", ["36", "48"], "23", 
        Grit::GitRuby::UserInfo.new("Author Name <author@email.hu>"),
        "2011 01 05", 
        Grit::GitRuby::UserInfo.new("Committer Name <committer@email.hu>"),
        "2011 05 05", ["Line1", "Line2"])
        
    @patch = Patch.new(@repository, @orig_patch)
    @patch.stubs(:comments).returns(["comment1", "comment2"])
  end
  
  test "sha id" do
    assert_equal @patch.sha, "24"
  end
  
  test "author name" do
    assert_equal @patch.author_name, "Author Name"
  end
  
  test "author email" do
    assert_equal @patch.author_email, "author@email.hu"
  end
  
  test "date" do
    assert_equal @patch.date, "2011 01 05"
  end
  
  test "message" do
    assert_equal @patch.message, "Line1\nLine2"
  end
  
  test "parents" do
    assert_equal @patch.parent.sha, "36"
  end
  
  test "tree" do
    assert_equal @patch.tree, "23"
  end
  
  test "comments" do
    assert_equal @patch.comments[0], "comment1"
    assert_equal @patch.comments[1], "comment2"
  end
  
  test "tags" do
    tags1 = Object.new
    tags1.expects(:name).returns("name1")

    id1 = Object.new
    id1.expects(:sha).returns("24")
    tags1.expects(:commit).returns(id1)

    tags2 = Object.new
    id2 = Object.new
    id2.expects(:sha).returns("36")
    tags2.expects(:commit).returns(id2)

    @repository.stubs(:tags).returns([tags1, tags2])
    tags = @patch.tags
    assert tags.include?("name1")
    assert ! tags.include?("name2")
  end
  
  test "diffs" do
    
  end
end
