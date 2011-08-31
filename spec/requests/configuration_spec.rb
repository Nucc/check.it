require "spec_helper"

describe "Configuration", :type => :request do
  before :each do
  end

  describe "should have option for" do

    it "repository_path" do
      CONFIG["repository_path"].should == "#{::Rails.root.to_s}/test/fixtures"
    end

  end

end