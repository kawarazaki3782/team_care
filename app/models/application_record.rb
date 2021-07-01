class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end

def microposts
  return Micropost.where(user_id: self.id)
end

def user
  #インスタンスメソッドないで、selfはインスタンス自身を表す
  return User.find_by(id: self.user_id)
end
