class NotificationsController < ApplicationController
    def index
        #current_userの投稿に紐づいた通知一覧
          @notifications = current_user.passive_notifications.page(params[:page]).per(5)
        #@notificationの中でまだ確認していない(indexに一度も遷移していない)通知のみ
          @notifications.where(checked: false).each do |notification|
              notification.update(checked: true)
          end
      end
end
