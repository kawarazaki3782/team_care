class Block < ApplicationRecord
  validates :blocker_id, presence: true
  validates :blocked_id, presence: true
  
  belongs_to :blocker, class_name: 'User', optional: true
  belongs_to :blocked, class_name: 'User', optional: true
end
