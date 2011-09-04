require 'spec_helper'
require 'lib/response.rb'

describe Response do
  
  before :each do
    @response = Response.new({:one => :two, :three => "four"})
  end
  
  it "should have to_json interface" do
    @response.should respond_to(:to_json)    
  end
  
  it "should have to_xml interface" do
    @response.should respond_to(:to_xml)    
  end
  
  it "should generate xml" do
    xml = Hpricot.XML(@response.to_xml)
    xml.should have_tag("/response", :count => 1)
    xml.should have_tag("/response/one", "two", :count => 1)
    xml.should have_tag("/response/three", "four", :count => 1)
  end
  
  it "should generate json" do
    json = @response.to_json
    json.should == "{\"response\":{\"three\":\"four\",\"one\":\"two\"}}"
  end

  it "should behave like a struct" do
    response = Response.new({:a => 2})
    response.a.should == "2"
  end
end
