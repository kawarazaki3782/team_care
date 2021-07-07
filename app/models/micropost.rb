class Micropost < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  mount_uploader :post_image, PostImageUploader
  validate :post_image_size
  belongs_to :category, optional: true
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :favorites
  has_many :users, through: :favorites
  has_many :notifications,dependent: :destroy

  def microposts
    return Micropost.where(user_id: self.id)
  end
  
  def user
    #インスタンスメソッドないで、selfはインスタンス自身を表す
    return User.find_by(id: self.user_id)
  end

  def create_notification_by(current_user)
    notification=current_user.active_notifications.new(
      micropost_id:self.id,
      visited_id:user_id,
      action:"like"
    )
    notification.save if notification.valid?
  end

  def create_notification_comment!(current_user, comment_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    temp_ids = Comment.select(:user_id).where(micropost_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
        save_notification_comment!(current_user, comment_id, temp_id['user_id'])
    end
    #常に投稿者に通知を送る
    save_notification_comment!(current_user, comment_id, user_id) 
end

def save_notification_comment!(current_user, comment_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      micropost_id: id,    
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    if notification.visiter_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
 end

  
  private

# アップロードされた画像のサイズをバリデーションする
def post_image_size
  if post_image.size > 5.megabytes
    errors.add(:post_image, "should be less than 5MB")
  end
end

def self.search(search)
  return Micropost.all unless search
  Micropost.where(["content like?", "%#{search}%"])
end
end
