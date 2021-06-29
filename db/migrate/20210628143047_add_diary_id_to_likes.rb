class AddDiaryIdToLikes < ActiveRecord::Migration[6.1]
  def change
    add_reference :likes, :diary, null: false, foreign_key: true
  end
end
