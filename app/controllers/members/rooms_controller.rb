class Members::RoomsController < ApplicationController
  def create
    @room = Room.create
    @entry1 = Entry.create(room_id: @room.id, member_id: current_member.id)
    @entry2 = Entry.create((entry_params).merge(room_id: @room.id))
    redirect_to room_path(@room.id)
  end

  def show
    @room = Room.find(params[:id])
    if Entry.where(member_id: current_member.id,room_id: @room.id).present?
      @chats = @room.chats.all
      @chat = Chat.new
      @entries = @room.entries
      @another_entry = @entries.where.not(menber_id: current_member.id).first
    else
      redirect_back(fallback_location: root_path)
    end
  end
  
   private
    def entry_params
      params.require(:entry).permit(:member_id, :room_id)
    end

end
