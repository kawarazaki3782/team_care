class Diary < ApplicationRecord
  default_scope -> { order(created_at: :desc) }

  validates :user_id, presence: true
  validates :title, presence: true
  validates :content, presence: true, length: { maximum: 5000 }
  validates :status, inclusion: { in: Diary.statuses.keys }

  belongs_to :user
  belongs_to :category, optional: true
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :favorites
  has_many :users, through: :favorites
  has_many :notifications, dependent: :destroy

  mount_uploader :diary_image, DiaryImageUploader
  enum status: { draft: 0, published: 1 }

  def create_notification_by(current_user)
    current_user.active_notifications.create(
      diary_id: id,
      visited_id: user_id,
      action: 'diary_like'
    )
  end

  def create_notification_comment(current_user, comment_id, diary)
    comment_users = Comment.select(:user_id).where(diary_id: id).where.not(user_id: current_user.id).distinct 
    comment_users = comment_users.select {|user| user['user_id'] != diary.user_id}
    users = [diary,comment_users]
    users = users.flatten
    if users.blank?
      save_notification_comment(current_user, comment_id, user_id)
    else
      users.each do |user|
        save_notification_comment(current_user, comment_id, user['user_id'])
      end
    end
  end

  def save_notification_comment(current_user, comment_id, visited_id)
    notification = current_user.active_notifications.new(
      diary_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'diary_comment',
    )
    notification.checked = true if notification.visiter_id == notification.visited_id
    notification.save
  end
end
