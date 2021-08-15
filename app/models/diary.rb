class Diary < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :title, presence: true
  validates :content, presence: true, length: { maximum: 5000 }
  belongs_to :category, optional: true
  has_many :comments, dependent: :destroy
  mount_uploader :diary_image, DiaryImageUploader
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  enum status: { draft: 0, published: 1 }
  has_many :favorites
  has_many :users, through: :favorites
  validates :status, inclusion: { in: Diary.statuses.keys }
  has_many :notifications, dependent: :destroy

  def create_notification_by(current_user)
    notification = current_user.active_notifications.new(
      diary_id: id,
      visited_id: user_id,
      action: 'diary_like'
    )
    notification.save if notification.valid?
  end

  def create_notification_comment!(current_user, comment_id, diary)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    hoge_ids = diary.user_id
    hoge_ids.push(Comment.select(:user_id).where(diary_id: id).where.not(user_id: current_user.id).distinct)
    hoge_ids.each do |hoge_id|
      save_notification_comment!(current_user, comment_id, hoge_id['user_id'])

    
    end
    save_notification_comment!(current_user, comment_id, user_id) if hoge_ids.blank?
  end

  def save_notification_comment!(current_user, comment_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知するexi
    notification = current_user.active_notifications.new(
      diary_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'diary_comment',
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    notification.checked = true if notification.visiter_id == notification.visited_id
    notification.save if notification.valid?
  end
end
