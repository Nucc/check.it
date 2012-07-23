class ReactionsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :should_have_repository
  before_filter :should_have_patchid, :except => [:index]


  def index
    render :text => ""
  end

  def show
    commit = Commit.find_by_sha(params[:id])

    if commit
      @reactions = commit.reactions
    else
      render :text => ""
    end
  end

  def create

    commit_diff_id = params[:reaction][:commit_diff_id].to_i

    if commit_diff_id > 0
      commit_diff = CommitDiff.find(commit_diff_id)
    else
      render :text => "Please update the repository, because patch is missing..."
      return
    end

    @reaction = Reaction.find_by_user_id_and_commit_diff_id(@user.id, commit_diff_id) || Reaction.new

    if commit_diff
      @reaction.commit_diff = commit_diff
      @reaction.user = @user
      @reaction.status = params[:commit]
    else
      render :text => ""
      return
    end

    # start rendering

    params[:id] = session[:patch_id]
    show

    respond_to do |wants|
      if @reaction.save
        #create_notification(@reaction)
        expire_fullsite_caches

        wants.html { render :action => "show" }
        wants.js   { render :action => "show", :layout => false}
      else
        wants.html { render :action => "new" }
      end
    end
  end

  def update
    render :text => ""
  end

private

=begin
  def create_notification(reaction)
    repo = Repository.by_name(session[:repository_id])
    patch = repo.patch(session[:patch_id])
    author =  User.find_by_email(patch.author_email)

    if author
      if reaction.accepted?
        send_notification(Notify::ACCEPT, author)
      else
        send_notification(Notify::DECLINED, author)
      end
    end
  end
=end

end
