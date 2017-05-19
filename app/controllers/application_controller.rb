class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  before_action :configure_permitted_parameters, if: :devise_controller?

  include Authenticable

  def after_sign_in_path_for(resource)
    "/" + current_user.id.to_s
  end

  def serialize_as_json(notification)
    notification.as_json(include: { user: { only: [:email, :name] },
                                    notified_by: { only: :name },
                                    post: { only: :description } })
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(:email, :name, :password, :password_confirmation)
    end
    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:email, :name, :password, :password_confirmation, :current_password)
    end
  end
end
