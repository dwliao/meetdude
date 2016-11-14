class PostsController < ApplicationController
  def append_posts
    @posts = []
    if params[:user_id]
      @posts = Post.includes(:user).includes(:target)
        .which_related_to(
          params[:user_id],
          params[:search_type],
          params[:start_search_time],
          params[:is_forward],
          params[:limit_number])
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
