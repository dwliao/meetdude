class Api::V1::UsersController < ApplicationController
  before_action :authenticate_with_token!, only: [:update, :destroy, :index_friendships]
  respond_to :json

  def show
    @user = User.find(params[:id])
    render json: @user.to_json(except: [:auth_token])
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: 201, location: [:api, user]
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def update
    user = current_user

    if user.update(user_params)
      render json: user, status: 200, location: [:api, user]
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def destroy
    user = current_user
    user.destroy
    head 204
  end

  def show_friendship
    friend = User.find(params[:id])
    @friendship = current_user.friendships.find_by(friend_id: friend.id)

    if @friendship.present?
      render json: @friendship, status: 200
    else
      render json: {}, status: 200
    end
  end

  def friend_request
    friend = User.find(params[:id])
    @friendship = current_user.friendships.build(friend_id: friend.id)

    if @friendship.user_id != @friendship.friend_id
      @friendship.save
      render json: @friendship, status: 201
    else
      render json: { errors: "Can't send friend request to yourself" }, status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end

end
