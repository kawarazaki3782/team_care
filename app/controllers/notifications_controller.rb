class NotificationsController < ApplicationController
  def index
    @notifications = current_user.passive_notifications.page(params[:page]).per(5)
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end

  def destroy
    if @notifications = current_user.passive_notifications.destroy_all
    else
      flash[:danger] = '通知を削除できません'
    end
    redirect_back(fallback_location: root_path)
  end
end
