class Api::V1::NotificationsController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json

  def index
    respond_with current_user.notifications
  end

  def show
    @notification = current_user.notifications.find(params[:id])
    @notification.have_read
    respond_with @notification
  end

end
