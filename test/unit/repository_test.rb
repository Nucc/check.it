require 'test_helper'

class RepositoryTest < ActiveSupport::TestCase

  setup do
    @repo = Repository.new("/Users/developer/Desktop/have2do.it")
  end

  test "repository should have commits" do
    assert_equal(@repo.patches.length, 30)
  end
  
  test "repository should have commits exactly 10 commits" do
    assert_equal(@repo.patches(10).length, 10)
  end

  test "test find commit" do
    patch = @repo.patch("ccfddb93b8b41f3656f877e48c84b092c9fab462")
    assert_not_nil(patch)
  end
end
