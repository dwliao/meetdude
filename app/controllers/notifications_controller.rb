class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications
    respond_to do |format|
      format.json { render json: @notifications }
    end
  end

  def show
    @notification = Notification.find_by(params[:id])
    respond_to do |format|
      format.json { render :json => { post: @notification.post, name: @notification.user.name, created_at: @notification.created_at }.to_json }
    end
  end

  def link_through
    @notification = Notification.find_by(params[:id])
    @notification.have_read
    respond_to do |format|
      format.json { render json: @notification}
    end
  end

end
