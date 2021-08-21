class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  validates :user_id, presence: true
  validates :room_id, presence: true
  validates :content, presence: true, length: { maximum: 150 }

  def create_notification_dm!(current_user, visited_id)
    notification = current_user.active_notifications.new(
      visited_id: visited_id,
      action: 'dm'
    )
    notification.save if notification.valid?
  end
end
