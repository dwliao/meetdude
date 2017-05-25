class Api::V1::FriendshipsController < ApplicationController
  before_action :authenticate_with_token!

  respond_to :json

  def index
    respond_with Friendship.where(params[id: current_user.id])
  end
end
