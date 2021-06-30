class ChangeColumnToLikes < ActiveRecord::Migration[6.1]
  def change
    add_reference :likes, :micropost, foreign_key: true
  end
end
