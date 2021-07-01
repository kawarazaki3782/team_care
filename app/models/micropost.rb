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

  # def microposts
  #   return Micropost.where(user_id: self.id)
  # end

  # def user
  #   #インスタンスメソッドないで、selfはインスタンス自身を表す
  #   return User.find_by(id: self.user_id)
  # end

  
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
