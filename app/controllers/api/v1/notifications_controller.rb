class Api::V1::NotificationsController < ApplicationController
  before_action :authenticate_with_token!

  def index
    @notifications = current_user.notifications
    render json: serialize_as_json(@notifications), status: 200
  end

  def show
    @notification = current_user.notifications.find(params[:id])
    @notification.have_read
    render json: serialize_as_json(@notification), status: 200
  end
end
