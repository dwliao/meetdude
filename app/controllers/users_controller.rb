class UsersController < ApplicationController
  def index
    if params[:name]
      if !params[:name].empty?
        @users = User.where("name LIKE ?", "%#{params[:name]}%")
      else
        @users = []
      end
    else
      @users = User.all
    end

    respond_to do |format|
      format.html
      format.json { render json: { :users => @users }}
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end