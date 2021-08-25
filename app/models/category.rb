class Category < ApplicationRecord
  validates :name, presence: true, length: { maximum: 10 }, uniqueness: true
  validates :user_id, presence: true

  has_many :microposts
  has_many :diaries

  belongs_to :user, optional: true
end
