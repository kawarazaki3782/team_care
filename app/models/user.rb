class User < ApplicationRecord
  before_save { email.downcase! }
  attr_accessor :remember_token
  validates :name,  presence: true, length: { maximum: 15 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
  validates :profile, length: { maximum: 1000 }
  validates :birthday, presence: true
  validates :address, presence: true
  validates :gender, presence: true
  validates :long_teamcare, presence: true
  validates :password_confirmation, presence: true, length: { minimum: 6 }


  mount_uploader :profile_image, ImageUploader
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                  foreign_key: "followed_id",
                                  dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :comments, dependent: :destroy
  has_many :diaries, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_microposts, through: :likes, source: :micropost
  has_many :liked_diaries, through: :likes, source: :diary
  has_many :favorites
  has_many :categories
  has_many :fav_microposts, through: :favorites, source: :micropost
  has_many :fav_diaries, through: :favorites, source: :diary
  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :rooms, through: :entries, source: :room
  has_many :active_notifications, class_name: "Notification", foreign_key: "visiter_id", dependent: :destroy
  has_many :active_notifications, class_name: "Notification", foreign_key: "visited_id", dependent: :destroy
  has_many :blocking_blocks,foreign_key: "blocker_id", class_name: "Block",  dependent: :destroy
  has_many :blocking, through: :blocking_blocks, source: :blocked
  has_many :blocker_blocks,foreign_key: "blocked_id", class_name: "Block", dependent: :destroy
  has_many :blockers, through: :blockers_blocks, source: :blocker

   # 渡された文字列のハッシュ値を返す
   def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
   end

   # ランダムなトークンを返す
   def User.new_token
    SecureRandom.urlsafe_base64
   end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end

 # ユーザーのステータスフィードを返す
 def feed
  following_ids = "SELECT followed_id FROM relationships
                   WHERE follower_id = :user_id"
  Micropost.where("user_id IN (#{following_ids})
                   OR user_id = :user_id", user_id: id)
 end

  # ユーザーをフォローする
  def follow(other_user)
    following << other_user
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

  # ユーザーが投稿に対してすでにいいねしていたらtrueを返す
  def already_liked?(micropost)
    self.likes.exists?(micropost_id: micropost.id)
  end

  def already_liked2?(diary)
    self.likes.exists?(diary_id: diary.id)
  end
  
  def create_notification_follow!(current_user)
    temp = Notification.where(["visiter_id = ? and visited_id = ? and action = ? ",current_user.id, id, 'follow'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end

  #すでにブロック済みであればture返す
  def blocking?(other_user)
      self.blocking.include?(other_user)
  end

  def block(other_user)
    passive_relationships = self.current_user.passive_relationships
    passive_relationships.each do |p|
    if p.followed_id == other_user.id？
      flash[:danger] = "フォロワーしている利用者はブロックできません"
      redirect_back(fallback_location: root_path)
    else
      self.blocking_blocks.create(blocked_id: other_user.id)
    end
  end
  end

  #ユーザーのブロックを解除する
  def unblock(other_user)
    self.blocking_blocks.find_by(blocked_id: other_user.id).destroy
  end 

  
end
