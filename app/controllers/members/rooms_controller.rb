class Members::RoomsController < ApplicationController

  def index
    # @rooms = Room.all
    @rooms = Entry.where(member_id: current_member.id)
    # @room = Room.find(params[:id])
    # member = Entry.where(member_id: member.id) if member.id !=current_member.id
    # if Entry.where(member_id: current_member.id,room_id: @room.id).present?
    #   @entries = @room.entries
    # else
    #   redirect_back(fallback_location: root_path)
    # end
  end

  def show
    @room = Room.find(params[:id])
    if Entry.where(member_id: current_member.id,room_id: @room.id).present?
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
