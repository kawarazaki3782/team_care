class Category < ApplicationRecord
  has_many :microposts
  has_many :diaries
  belongs_to :user, optional: true
  validates :name, presence: true, length: { maximum: 20 }, uniqueness: true
  validates :user_id, presence: true

end



