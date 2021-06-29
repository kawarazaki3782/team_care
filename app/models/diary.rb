class Diary < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  ALLOWED_PARAMS = [:id, :title, :diary_image, :content]
  validates :user_id, presence: true
  validates :title, presence: true
  validates :content, presence: true
  belongs_to :category, optional: true
  has_many :comments, dependent: :destroy
  mount_uploader :diary_image, DiaryImageUploader
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
end
