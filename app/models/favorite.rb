class Favorite < ApplicationRecord
    belongs_to :user
    belongs_to :micropost, optional: true
    belongs_to :diary, optional: true
end