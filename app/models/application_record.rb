class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.diary_ranks
    Diary.where(id: Like.group(:diary_id).order('count(diary_id) desc').limit(5).pluck(:diary_id))
  end

  def microposts
    Micropost.where(user_id: id)
  end

  def user
    User.find_by(id: id)
  end

  def self.micropost_favorites(user_bigint)
    Favorite.where(user_id: user_bigint).order(created_at: :desc).pluck(:micropost_id)
  end

  def self.diary_favorites(user_bigint)
    Favorite.where(user_id: user_bigint).order(created_at: :desc).pluck(:diary_id)
  end

  def self.following_microposts(user_bigint)
    Micropost.where(user_id: [user_bigint.following_ids]).order('created_at DESC')
  end

  def self.following_diaries(user_bigint)
    Diary.where(user_id: [user_bigint.following_ids]).order('created_at DESC')
  end

  def self.category_microposts(category)
    Micropost.where(category_id: category).order(created_at: :desc)
  end

  def self.category_diaries(category)
    Diary.where(category_id: category).order(created_at: :desc)
  end

  def self.draft_index(current_user)
    Diary.where(user_id: current_user, status: :draft).order('created_at DESC').all
  end

  def self.diary_index(current_user)
    Diary.where(user_id: current_user, status: :published).order('created_at DESC').all
  end

  def create_notification_dm!(current_user, visited_id)
    notification = current_user.active_notifications.create(
      visited_id: visited_id,
      action: 'dm'
    )
  end
end
