class Members::RoomsController < ApplicationController
  def index
    # request_ids = current_member.rooms.pluck(:request_id)
    @rooms = Request.where(id: current_member.rooms.pluck(:request_id))
                    .where.not(is_active: 'end_transaction')
                    .page(params[:page]).per(10)
    # binding.pry
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
