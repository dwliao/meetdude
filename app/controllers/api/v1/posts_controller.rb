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
    limit_number = 15
    @user = User.find(params[:id])
    page = params[:page].nil? ? 0 : params[:page]
    get_user_post = Post.where(target_id: @user.id).recent
    @final_page_number = get_user_post.length / limit_number
    @posts = get_user_post.limit(limit_number).offset(page.to_i * limit_number)

    if page.to_i >= 0 && page.to_i < @final_page_number
      render json: { data: serialize_json_for(@posts),
                     final_page_number: @final_page_number}, status: 200
      elsif page.to_i == @final_page_number
        render json: { data: serialize_json_for(@posts),
                       final_page_number: @final_page_number,
                       message: "This is the final page" }, status: 200
    else
      render json: { message: "No data" }, status: 422
    end
  end

  private

  def post_params
    params.require(:post).permit(:description, :target_id)
  end

  def serialize_json_for(post)
    post.as_json(include: { target: { only: :name },
                            user: { only: :name } })
  end
end
