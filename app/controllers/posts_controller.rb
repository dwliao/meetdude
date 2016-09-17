class PostsController < ApplicationController
  def append_posts_by_target_id
    target_id = params[:target_id]
    first_post_time = params[:first_post_time]
    last_post_time = params[:last_post_time]
    isUpdate = params[:isUpdate] === 'true'
    append_number = params[:append_number] || 10

    @posts = []
    if target_id
      # Get all new posts
      if isUpdate && last_post_time
        time = Time.at(last_post_time.to_i)
        @posts = Post
          .includes(:user)
          .where(['target_id = :id and updated_at > :time', { id: target_id, time: time }])
          .order(updated_at: :desc)
      # Get some old posts
      elsif !isUpdate && first_post_time
        time = Time.at(first_post_time.to_i)
        @posts = Post
          .includes(:user)
          .where(['target_id = :id and updated_at < :time', { id: target_id, time: time }])
          .order(updated_at: :desc)
          .limit(append_number)
      # Get some newest posts
      else
        @posts = Post
          .includes(:user)
          .where(target_id: target_id)
          .order(updated_at: :desc)
          .limit(append_number)
      end
    end
    render :partial => "common/postWrap", :collection => @posts, :as => :post, :content_type => "text/html"
  end

  def create
    user_id = params[:user_id]
    description = params[:description]
    target_id = params[:target_id]

    @post = Post.new(
      user_id: user_id,
      description: description,
      target_id: target_id)

    if @post.save
      data = { post: @post }
    else
      data = { post: nil }
    end

    respond_to do |format|
      format.json { render json: data }
    end
  end

  private

  def post_params
    params.require(:post).permit(:user_id, :description, :target_id)
  end
end