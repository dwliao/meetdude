class PostsController < ApplicationController
  def append_posts
    user_id = params[:user_id]
    search_type = params[:search_type]
    start_search_time = params[:start_search_time]
    is_forward = params[:is_forward] == 'true'
    limit_number = params[:limit_number]

    @posts = []
    if user_id
      @post = Post
      .includes(:user)
      .includes(:target)
      .which_related_to(user_id, search_type, start_search_time, is_forward, limit_number)


      #if search_type == 'TO'
      #  if start_search_time
      #    time = Time.at(start_search_time.to_i)
      #    if is_forward # Get all new posts
      #      @posts = Post
      #        .includes(:user)
      #        .includes(:target)
      #        .where(['target_id = :id and updated_at > :time', { id: user_id, time: time }])
      #        .recent
      #    else # Get some old posts
      #      @posts = Post
      #        .includes(:user)
      #        .includes(:target)
      #        .where(['target_id = :id and updated_at < :time', { id: user_id, time: time }])
      #        .recent
      #        .limit(limit_number)
      #    end
      #  else # Get some newest posts
      #    @posts = Post
      #      .includes(:user)
      #      .includes(:target)
      #      .where(target_id: user_id)
      #      .recent
      #      .limit(limit_number)
      #  end
      #elsif search_type == 'FROM'
      #end
    end
    render :partial => "common/postWrap", :collection => @posts, :as => :post, :content_type => "text/html"
  end

  def create
    post = Post.new(post_params)
    if post.save
      data = {
        status: "success",
        post: post
      }
    else
      data = { status: "failed" }
    end
    respond_to do |format|
      format.json { render json: data }
    end
  end

  def get
    post = Post.find(params[:id])
    if post
      data = {
        status: "success",
        post: post
      }
    else
      data = { status: "failed" }
    end
    respond_to do |format|
      format.json { render json: data }
    end
  end

  def update
    post = Post.find(params[:id])
    if post.update(post_params)
      data = {
        status: "success",
        post: post
      }
    else
      data = { status: "failed" }
    end
    respond_to do |format|
      format.json { render json: data }
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    data = {
      status: "success",
    }
    respond_to do |format|
      format.json { render json: data }
    end
  end

  private

  def post_params
    params.require(:post).permit(:user_id, :description, :target_id)
  end
end
