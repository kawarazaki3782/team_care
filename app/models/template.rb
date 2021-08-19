class Template < ApplicationRecord
  belongs_to :user, optional:true
  validates :content,presence: true, length: { maximum: 140 }
  validates :user_id, presence: true
end
