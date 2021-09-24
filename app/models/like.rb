# frozen_string_literal: true

class Like < ApplicationRecord
  belongs_to :member
  belongs_to :request

  # 通知：いいね
  def create_notification_like!(current_member)
    # すでに通知があるか。順番に必要情報を記載
    temp = Notification.where([" visitor_id = ? and visited_id = ? and request_id = ? and action =? ", current_member.id, member_id, id, "like"])
    # blank?でtempがない場合のみ新規作成
    if temp.blank?
      # visitor_idはcurrent_member.idのため記載なし
      notification = current_member.go_notifications.new(visited_id: member_id, request_id: id, action: "like")
      # 自分の投稿に対してはすでに通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification valid?
    end
  end
end
