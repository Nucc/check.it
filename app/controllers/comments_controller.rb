class CommentsController < ApplicationController
  before_filter :find_comment, :only => [:show, :edit, :update, :destroy]

  # GET /comments
  # GET /comments.xml
  def index
    @comments = Comment.all

    respond_to do |wants|
      wants.html # index.html.erb
      wants.xml  { render :xml => @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.xml
  def show
    respond_to do |wants|
      wants.html # show.html.erb
      wants.js   { render "show.html", :layout => false}
      wants.xml  { render :xml => @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.xml
  def new
    @comment = Comment.new
    @comment.commit_sha = params[:id]
    @comment.block = params[:block]
    @comment.line = params[:line]

    respond_to do |wants|
      wants.html # new.html.erb
      wants.js { render "new.html", :layout => false }
      wants.xml  { render :xml => @comment }
    end
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.xml
  def create
    @commit = Commit.find_by_sha(params[:comment][:commit_sha])
    if @commit.nil?
      @commit = Commit.new
      @commit.sha = params[:comment][:commit_sha]
      @commit.save!
    end
    
    @comment = Comment.new(params[:comment])
    @comment.commit = @commit
    @comment.user = current_user

    respond_to do |wants|
      if @comment.save
        wants.html { render :action => "show" }
        wants.js   { render :action => "show", :layout => false}
        wants.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        wants.html { render :action => "new" }
        wants.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    respond_to do |wants|
      if @comment.update_attributes(params[:comment])
        wants.html { redirect_to(@comment) }
        wants.xml  { head :ok }
      else
        wants.html { render :action => "edit" }
        wants.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment.destroy

    respond_to do |wants|
      wants.html { redirect_to(comments_url) }
      wants.xml  { head :ok }
    end
  end

  private
    def find_comment
      @comment = Comment.find(params[:id])
    end

end
