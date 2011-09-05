require 'spec_helper'

describe "patches/index.html.erb" do
  
  
  it "should have an 'update repository' link to refresh the patch set" do    

    patches = Array.new
    patches.stubs(:number).returns(1)
    patches.stubs(:prev?).returns(false)
    patches.stubs(:next?).returns(false)
    assign :patches, patches

    render
    
    rendered.should have_tag("a.update", :text => "Update the repository")
  end
end
