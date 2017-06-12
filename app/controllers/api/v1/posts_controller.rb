class Api::V1::PostsController < ApplicationController
  before_action :authenticate_with_token!, only: [:create, :destroy, :index]
  respond_to :json

  def create
    post = current_user.posts.build(post_params)
    if post.save
      render json: post, status: 201
    else
      render json: { errorr: post.errors }, status: 422
    end
  end

  def destroy
    post = Post.find(params[:id])
    if post.user.id == current_user.id || post.target.id == current_user.id
      post.destroy
      head 204
    else
      render json: { message: "No authorization" }, status: 401
    end
  end

  def index
    user = User.find(params[:id])
    page = params[:page].nil? ? 0 : params[:page]
    get_user_post = Post.where(target_id: user.id).recent
    post = get_user_post.limit(15).offset(page.to_i * 15)
    render json: serialize_json_for(post), status: 200
  end

  private

  def post_params
    params.require(:post).permit(:description, :target_id)
  end

  def serialize_json_for(post)
    post.to_json(include: { target: { only: :name },
                            user: { only: :name } })
  end
end
