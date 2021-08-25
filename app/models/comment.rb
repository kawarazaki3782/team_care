class Comment < ApplicationRecord
  validates :content, presence: true, length: { maximum: 140 }
  validates :user, presence: true

  belongs_to :user, optional: true
  belongs_to :micropost, optional: true
  belongs_to :diary, optional: true
end
