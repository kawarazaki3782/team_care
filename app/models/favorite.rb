class Favorite < ApplicationRecord
  validate :user_id
  
  belongs_to :user
  belongs_to :micropost, optional: true
  belongs_to :diary, optional: true

  def self.micropost_favorites(user_bigint)
    Favorite.where(user_id: user_bigint).order(created_at: :desc).pluck(:micropost_id)
  end

  def self.diary_favorites(user_bigint)
    Favorite.where(user_id: user_bigint).order(created_at: :desc).pluck(:diary_id)
  end
end
