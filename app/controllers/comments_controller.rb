class CommentsController < ApplicationController

  before_filter :find_comment, :only => [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!
  before_filter :should_have_repository
  before_filter :should_have_patchid, :except => [:index]
    
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
    @comment.commit_sha = session[:patch_id]
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
    repo = Repository.by_name(session[:repository_id])
    patch = repo.patch(params[:comment][:commit_sha])
    
    @comment = Comment.new(params[:comment])
    @comment.commit_diff = CommitDiff.create_or_find(patch)
    @comment.user = @user

    respond_to do |wants|
      if @comment.save
        create_notify(params[:comment])
        
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
  
  def create_notify(comment)
    repo = Repository.by_name(session[:repository_id])
    patch = repo.patch(comment[:commit_sha])
    
    commenters = Array.new
    commenters << @user.email
    commenters << patch.author_email

    # notify the author
    author =  User.find_by_email(patch.author_email)
    if author and author.email != @user.email
      send_notification(Notify::PATCH, author)
    end


    # notify the commenters
    comments = Comment.includes([:user]).
                       where(['comments.commit_diff_id = ? and comments.block = ? and comments.line = ?',
                               patch.diff_sha, comment[:block], comment[:line]]
                            ).all

    comments.each do |comment|
      if not commenters.include?(comment.user.email)
        commenters << comment.user.email        
        send_notification(Notify::COMMENT, comment.user)
      end
    end
  end

  def send_notification(topic, to_user)
    notify = Notify.new
    notify.topic = topic
    notify.status = Notify::UNREAD
    notify.repository_id = session[:repository_id]
    notify.user = to_user
    notify.comment = @comment
    notify.save!
  end
  
end
