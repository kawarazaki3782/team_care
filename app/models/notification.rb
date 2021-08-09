class Notification < ApplicationRecord
  default_scope -> { order(created_at: :desc) }
  belongs_to :micropost, optional: true
  belongs_to :diary, optional: true
  belongs_to :comment, optional: true
  belongs_to :visiter, class_name: 'User', foreign_key: 'visiter_id', optional: true
  belongs_to :visited, class_name: 'User', foreign_key: 'visited_id', optional: true
  validates :action, inclusion: { in: %w[like comment follow comment2 like2] }
end
