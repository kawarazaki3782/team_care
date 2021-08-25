class Entry < ApplicationRecord
  validates :user_id, presence: true, uniqueness: { scope: :room_id }
  validates :room_id, presence: true

  belongs_to :user
  belongs_to :room
end
