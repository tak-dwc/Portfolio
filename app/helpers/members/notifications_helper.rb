module Members::NotificationsHelper
  def notification_form(notification)
    @visitor = notification.visitor
    @comment = nil
    @visitor_comment = notification.comment_id
    # notification.actionがfollowかlikeかcommentか
    case notification.action
    when "follow" then
      tag.a(notification.visitor.nickname, href: member_path(@visitor)) + "があなたをフォローしました"
    when "like" then
      tag.a(notification.visitor.nickname, href: member_path(@visitor)) + "が" + tag.a('あなたの投稿', href: request_path(notification.request.id)) + "にいいねしました"
    when "comment" then
      @comment = Comment.find_by(id: @visitor_comment)&.comment
      tag.a(notification.visitor.nickname, href: member_path(@visitor)) + "が" + tag.a('あなたの投稿', href: request_path(notification.request.id)) + "にコメントしました"
    end
  end

  # 通知未確認マーク用
  def unchecked_notifications
    current_member.come_notifications.uncheck
  end
end
