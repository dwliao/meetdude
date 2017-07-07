class Api::V1::NotificationsController < ApplicationController
  before_action :authenticate_with_token!

  def index
    limit_number = 8
    user_notification = current_user.notifications.order("updated_at DESC")
    page = params[:page].nil? ? 0 : params[:page]
    final_page_number = user_notification.length / limit_number
    @notifications = user_notification.limit(limit_number).offset(page.to_i * limit_number)

    if page.to_i >= 0 && page.to_i < final_page_number
      render json: { notifications: serialize_json_for(@notifications),
                     final_page_number: final_page_number }, status: 200
      elsif page.to_i == final_page_number
        render json: { notifications: serialize_json_for(@notifications),
                       final_page_number: final_page_number,
                       message: "This is the final page" }, status: 200
    else
      render json: { message: "No data" }, status: 422
    end
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
