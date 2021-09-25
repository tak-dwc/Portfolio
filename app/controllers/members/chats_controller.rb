class Members::ChatsController < ApplicationController
  def create
    chat = Chat.new(chat_params)
    chat.member_id = current_member.id
    if chat.save
      redirect_back(fallback_location: root_path)
    else
      flash[:error] = "文字を入力してください"
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def chat_params
    params.require(:chat).permit(:member_id, :room_id, :body)
  end
end
