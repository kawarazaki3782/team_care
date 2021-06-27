class Category < ApplicationRecord
  has_many :microposts
  validates :name, presence: true, length: { maximum: 20 },uniqueness: true
end
