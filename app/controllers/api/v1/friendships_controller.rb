class Api::V1::FriendshipsController < ApplicationController
  before_action :authenticate_with_token!

  respond_to :json

  def index
    respond_with Friendship.where(params[id: current_user.id])
  end

  def create
    @friendship = current_user.friendships.build(friend_params)

    if @friendship.user_id != @friendship.friend_id
      @friendship.save
      render json: { friendship: @friendship, message: "好友邀請已送出" }, status: 201
    else
      render json: { errors: "Can't add yourself to be friend" }, status: 422
    end
  end

  private

  def friend_params
    params.require(:friendship).permit(:user_id, :friend_id, :state)
  end
end
