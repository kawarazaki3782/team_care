class Micropost < ApplicationRecord
  default_scope -> { order(created_at: :desc) }

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate :post_image_size

  belongs_to :user
  belongs_to :category, optional: true

  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :favorites
  has_many :users, through: :favorites
  has_many :notifications, dependent: :destroy

  mount_uploader :post_image, PostImageUploader

  def create_notification_by(current_user)
    current_user.active_notifications.create(
      micropost_id: id,
      visited_id: user_id,
      action: 'micropost_like'
    )
  end

  def create_notification_comment!(current_user, comment_id, micropost)
    comment_users = Comment.select(:user_id).where(micropost_id: id).where.not(user_id: current_user.id).distinct
    comment_users = comment_users.select {|user| user['user_id'] != micropost.user_id}
    users = [micropost,comment_users]
    users = users.flatten
      users.each do |user|
        save_notification_comment!(current_user, comment_id, user['user_id'])     
      end
        save_notification_comment!(current_user, comment_id, user_id) if users.blank?
  end

  def save_notification_comment!(current_user, comment_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      micropost_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'micropost_comment'
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    
    notification.checked = true if notification.visiter_id == notification.visited_id
    notification.save 
  end

  def self.like_top5_posts
    Micropost.where(id: Like.group(:micropost_id).order('count(micropost_id) desc').limit(5).pluck(:micropost_id))
  end

  def self.following_microposts(user_bigint)
    Micropost.where(user_id: [user_bigint.following_ids]).order('created_at DESC')
  end

  def self.category_microposts(category)
    Micropost.where(category_id: category).order(created_at: :desc)
  end

  private

  # アップロードされた画像のサイズをバリデーションする
  def post_image_size
    errors.add(:post_image, 'should be less than 5MB') if post_image.size > 5.megabytes
  end

  def self.search(search)
    return Micropost.all unless search

    Micropost.where(['content like?', "%#{search}%"])
  end
end
