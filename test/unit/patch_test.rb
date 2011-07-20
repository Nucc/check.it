require 'test_helper'
require 'grit.rb'

class PatchTest < ActiveSupport::TestCase
  
  setup do
    @patch = Patch.new
  end
  
  test "the truth" do
    assert true
  end
end
