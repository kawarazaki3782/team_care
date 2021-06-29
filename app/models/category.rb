class Category < ApplicationRecord
  has_many :microposts
  has_many :diaries
  validates :name, presence: true, length: { maximum: 20 },uniqueness: true
end
