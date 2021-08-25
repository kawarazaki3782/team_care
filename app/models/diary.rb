class Diary < ApplicationRecord
  default_scope -> { order(created_at: :desc) }

  mount_uploader :diary_image, DiaryImageUploader
  enum status: { draft: 0, published: 1 }

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

  def create_notification_by(current_user)
    current_user.active_notifications.create(
      diary_id: id,
      visited_id: user_id,
      action: 'diary_like'
    )
    notification.save 
  end

  def create_notification_comment!(current_user, comment_id, diary)
    comment_users = Comment.select(:user_id).where(diary_id: id).where.not(user_id: current_user.id).distinct 
    comment_users = comment_users.select {|user| user['user_id'] != diary.user_id}
    users = [diary,comment_users]
    users = users.flatten
      users.each do |user|
        save_notification_comment!(current_user, comment_id, user['user_id'])
      end
        save_notification_comment!(current_user, comment_id, user_id) if users.blank?
  end

  def save_notification_comment!(current_user, comment_id, visited_id)
    notification = current_user.active_notifications.new(
      diary_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'diary_comment',
    )
    notification.checked = true if notification.visiter_id == notification.visited_id
    notification.save 
  end

  def self.like_top5_diaries
    Diary.where(id: Like.group(:diary_id).order('count(diary_id) desc').limit(5).pluck(:diary_id))
  end

  def self.following_diaries(user_bigint)
    Diary.where(user_id: [user_bigint.following_ids]).order('created_at DESC')
  end

  def self.category_diaries(category)
    Diary.where(category_id: category).order(created_at: :desc)
  end

  def self.draft_index(current_user)
    Diary.where(user_id: current_user, status: :draft).order('created_at DESC').all
  end

  def self.diary_index(current_user)
    Diary.where(user_id: current_user, status: :published).order('created_at DESC').all
  end
end
