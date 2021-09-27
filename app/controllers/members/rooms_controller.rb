class Members::RoomsController < ApplicationController
  def index
    @rooms = current_member.rooms.page(params[:page]).per(10)
  end

  def show
      @room = Room.find(params[:id])
      @rate  = @room.request.rates.find_by(params[:id])
      # binding.pry
    if Entry.where(member_id: current_member.id, room_id: @room.id).present?
      @chats = @room.chats.all
      @chat = Chat.new
      @entries = @room.entries
    else
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def entry_params
    params.require(:entry).permit(:member_id, :room_id)
  end
end
