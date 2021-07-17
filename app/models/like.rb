class Like < ApplicationRecord
  belongs_to :user
  belongs_to :micropost, optional: true
  belongs_to :diary, optional: true
  validates :user_id, presence: true
  # validates_uniqueness_of :micropost_id, scope: :user_id
  # validates_uniqueness_of :diary_id, scope: :user_id
end
