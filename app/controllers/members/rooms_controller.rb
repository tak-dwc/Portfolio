class Members::RoomsController < ApplicationController
  def index
    @rooms = current_member.rooms.page(params[:page]).order(created_at: :desc).per(6)
    # rooms_request = current_member.rooms.select(:request_id)
    
    # column = params[:column]
    # if column.blank?
    #   @rooms = current_member.rooms.page(params[:page]).order(created_at: :desc).per(6)
    # elsif column == "in_transaction"   
    #   @rooms = Request.where(id: rooms_request).where(is_active: "in_transaction").page(params[:page]).order(created_at: :desc).per(6)
    # elsif column == "in_review"
    #   @rooms = Request.where(id: rooms_request).where(is_active: "in_review").page(params[:page]).order(created_at: :desc).per(6)
    # elsif column == "end_transaction"
    #   @rooms = Request.where(id: rooms_request).where(is_active: "end_transaction").page(params[:page]).order(created_at: :desc).per(6)
    # end
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
