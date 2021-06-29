class Like < ApplicationRecord
  belongs_to :user
  belongs_to :micropost
  belongs_to :diary
  validates_uniqueness_of :micropost_id, scope: :user_id
  validates_uniqueness_of :diary_id, scope: :user_id
end
