class Api::V1::NotificationsController < ApplicationController
  before_action :authenticate_with_token!

  def index
    @notifications = current_user.notifications.order("updated_at DESC")
    render json: serialize_json_for(@notifications), status: 200
  end

  def show
    @notification = current_user.notifications.find(params[:id])
    @notification.have_read
    render json: @notification.to_json(except: [:created_at, :updated_at]), status: 200
  end

  private

  def serialize_json_for(notification)
    notification.as_json(include: { notified_by: { only: :name },
                                    post: { only: :description } } )
  end
end
