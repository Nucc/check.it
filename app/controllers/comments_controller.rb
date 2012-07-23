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
        expire_fullsite_caches
        create_notifications(params[:comment])

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

  def create_notifications(comment)
    repo = Repository.by_name(session[:repository_id])
    patch = repo.patch(comment[:commit_sha])
    comments = find_the_comments_according_to(patch.diff_sha, comment[:block], comment[:line])

    do_not_notify(@user.email)
    notify_the_author(patch.author_email)
    notify_the_commenters (comments)
  end

  def notify_the_author(author_email)
    author =  User.find_by_email(author_email)
    @commenters << author_email
    if author and author.email != @user.email
      send_notification(Notification::PATCH, author)
    end
  end

  def find_the_comments_according_to(diff_sha, block, line)
    diff_id = CommitDiff.find_by_sha(diff_sha)
    Comment.includes([:user]).
            where(['comments.commit_diff_id = ? and comments.block = ? and comments.line = ?',
                  diff_id, block, line]).all
  end

  def do_not_notify(mail)
    @commenters ||= Array.new
    @commenters << mail
  end

  def notify_the_commenters(comments)
    @commenters ||= Array.new
    comments.each do |comment|
      if not @commenters.include?(comment.user.email)
        @commenters << comment.user.email
        send_notification(Notification::COMMENT, comment.user)
      end
    end
  end

  def send_notification(topic, to_user)
    notification = Notification.new
    notification.topic = topic
    notification.status = Notification::UNREAD
    notification.repository_id = session[:repository_id]
    notification.user = to_user
    notification.comment = @comment
    notification.save!
  end

end
