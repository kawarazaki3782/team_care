class Micropost < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  mount_uploader :post_image, PostImageUploader
  validate :post_image_size


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
