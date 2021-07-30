module NotificationsHelper

  def notification_form(notification)
    @visiter = notification.visiter
    @comment = nil
    your_post = link_to 'あなたの投稿', micropost_path(notification), style:"font-weight: bold;", remote: true
    your_diary = link_to 'あなたの日記', diary_path(notification), style:"font-weight: bold;", remote: true
    @visiter_comment = notification.comment_id
    #notification.actionがfollowかlikeかcommentか
      case notification.action
        when "follow" then
          tag.a(notification.visiter.name, style:"font-weight: bold;")+"があなたをフォローしました"
        when "like" then
          tag.a(notification.visiter.name, style:"font-weight: bold;")+"が"+tag.a('あなたの投稿', href:micropost_path(notification.micropost_id), style:"font-weight: bold;")+"にいいねしました"
        when "like2" then
          tag.a(notification.visiter.name, style:"font-weight: bold;")+"が"+tag.a('あなたの日記', href:diary_path(notification.diary_id), style:"font-weight: bold;")+"にいいねしました" 
        when "comment" then
          @comment = Comment.find_by(id: @visiter_comment)&.content
          tag.a(@visiter.name, style:"font-weight: bold;")+"が"+tag.a('あなたの投稿', href:micropost_path(notification.micropost_id), style:"font-weight: bold;")+"にコメントしました"
        when "comment2" then
          @comment = Comment.find_by(id: @visiter_comment)&.content
          tag.a(@visiter.name, style:"font-weight: bold;")+"が"+tag.a('あなたの投稿', href:diary_path(notification.diary_id), style:"font-weight: bold;")+"にコメントしました"
        end
     end

  def unchecked_notifications
    @notifications = current_user.passive_notifications.where(checked: false)
  end
end




