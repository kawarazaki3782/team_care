class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.last_week 
    Micropost.find(Like.group(:micropost_id).where(created_at: Time.current.all_week).order('count(micropost_id) desc').limit(5).pluck(:micropost_id))
  end

  def self.diary_last_week 
    Diary.find(Like.group(:diary_id).where(created_at: Time.current.all_week).order('count(diary_id) desc').limit(5).pluck(:diary_id))
  end

  
end






