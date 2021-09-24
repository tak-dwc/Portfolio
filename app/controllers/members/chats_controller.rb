class Members::ChatsController < ApplicationController
  def create
    chat = Chat.new(chat_params)
    chat.member_id = current_member.id
    if chat.save
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = "メッセージ送信に失敗しました。"
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def chat_params
    params.require(:chat).permit(:member_id, :room_id, :body)
  end
end
