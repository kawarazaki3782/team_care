class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def microposts
    Micropost.where(user_id: id)
  end

  def user
    User.find_by(id: id)
  end
  
  def create_notification_dm!(current_user, visited_id)
    notification = current_user.active_notifications.create(
      visited_id: visited_id,
      action: 'dm'
    )
  end
end
