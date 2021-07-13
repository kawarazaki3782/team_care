class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.last_week 
    Micropost.find(Like.group(:micropost_id).order('count(micropost_id) desc').limit(5).pluck(:micropost_id))
  end

  def self.diary_last_week 
    Diary.find(Like.group(:diary_id).order('count(diary_id) desc').limit(5).pluck(:diary_id))
  end
  
  def microposts
    return Micropost.where(user_id: self.id)
  end
  
  def user
    #インスタンスメソッドないで、selfはインスタンス自身を表す
    return User.find_by(id: self.id)
  end

  
  
end






