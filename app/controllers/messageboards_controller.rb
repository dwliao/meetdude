class MessageboardsController < ApplicationController
  def index
    @messageboards = Messageboard.all
  end

  def new
    @messageboard = Messageboard.all
  end

  def edit
    @messageboard = Messageboard.find(params[:id])
  end

  def create
    @messageboard = Messageboard.new(messageboard_params)

    if @messageboard.save
      redirect_to_messageboards_path
    else
      render :new
    end
  end

  def update
    @messageboard = Messageboard.find(params[:id])

    if @messageboard.update(messageboard_params)
      redirect_to messageboards_path
    else
      render :edit
    end
  end

  private

  def messageboard_params
    params.require(:messageboard).permit(:title, :description)
  end
end
