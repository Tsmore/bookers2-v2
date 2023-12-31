class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    message = Message.new(message_params)
    message.user_id = current_user.id
    if message.save
      redirect_to room_path(message.room_id)
    else
      redirect_back(fallback_location: room_path(message.room_id))
    end
  end

  def destroy
    message = Message.find(params[:id])
    message.destroy if message.user == current_user
    redirect_to room_path(message.room_id)
  end

  private

  def message_params
    params.require(:message).permit(:room_id, :message)
  end
end
