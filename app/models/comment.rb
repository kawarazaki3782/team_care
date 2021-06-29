class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :micropost
  belongs_to :diary
  validates :content, presence: true
end
