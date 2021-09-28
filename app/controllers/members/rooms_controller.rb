class Members::RoomsController < ApplicationController
  def index
    # @rooms = Request.where(id: current_member.rooms.select(:request_id)).where.not(is_active: 'end_transaction').page(params[:page]).per(10)
    @rooms = current_member.rooms.page(params[:page]).per(10)
  end

  def show
      @room = Room.find(params[:id])
      # binding.pry
      @rate  = @room.request.rates.find_by(params[:id])
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
