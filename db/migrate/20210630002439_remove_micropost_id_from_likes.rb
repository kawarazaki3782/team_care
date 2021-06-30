class RemoveMicropostIdFromLikes < ActiveRecord::Migration[6.1]
  def change
    remove_column :likes, :micropost_id, :integer
  end
end
