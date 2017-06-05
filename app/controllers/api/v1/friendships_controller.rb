class Api::V1::FriendshipsController < ApplicationController
  before_action :authenticate_with_token!

  respond_to :json

  def show_friendship
    friend = User.find(params[:id])
    @friendship = current_user.friendships.find_by(friend_id: friend.id)
    data = @friendship.present? ? @friendship : { state: "not_relation" }
    render json: data, status: 200
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

  def index_friendships
    @friendships = current_user.receive_friendships.pending
    respond_with @friendships
  end

  def accept_request
    friend = User.find(params[:id])
    @friendship = current_user.receive_friendships.find_by(user_id: friend.id)
    @friendship.be_friend!
    render json: { friendship: @friendship, message: "已成為好友"}, status: 200
  end

  def decline_request
    friend = User.find(params[:id])
    @friendship = current_user.receive_friendships.find_by(user_id: friend.id)
    @friendship.destroy
    head 204
  end
end
