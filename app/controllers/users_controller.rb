class UsersController < ApplicationController
  def search_users
    if params[:name] && !params[:name].empty?
      @users = User.where("name LIKE ?", "%#{params[:name]}%")
    else
      @users = []
    end
    respond_to do |format|
      format.json { render json: { :users => @users }}
    end
  end

  def show
    if params[:id]
      @user = User.find(params[:id])
    else
      render :file => "#{Rails.root}/public/404.html", :status => 404
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
