class MessageboardsController < ApplicationController
  def index
    @messageboards = Messageboard.all
  end

  def new
    @messageboard = Messageboard.all
  end

  def create
    @messageboard = Messageboard.new(messageboard_params)

    if @messageboard.save
      redirect_to_messageboards_path
    else
      render :new
    end
  end

  private

  def messageboard_params
    params.require(:messageboard).permit(:title, :description)
  end
end
