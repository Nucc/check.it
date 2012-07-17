class WallController < ApplicationController

  layout "reviewer"

  before_filter :authenticate_user!

  def index
    @entries = []
    @entries << Comment.all(:limit => 30, :order => "created_at desc")
    @entries << Commit.all(:limit => 30, :order => "created_at desc")
    @entries << Reaction.all(:limit => 30, :order => "created_at desc")
    @repositories = Repository.all

    @entries.flatten!
    @entries.sort!{|i,j| i.created_at.to_i <=> j.created_at.to_i }
    @entries.reverse!


  end

end
