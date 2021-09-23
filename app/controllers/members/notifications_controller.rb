class Members::NotificationsController < ApplicationController
  def index
    @notifications = current_member.come_notifications.page(params[:page]).per(3)
    @notifications.where(checked: false).each do |notification|
      notification.update_attributes(checked: true)
    end
  end

  #通知削除
  def destroy_all
    @notifications = current_member.come_notifications.destroy_all
    redirect_to notifications_path
  end
end
