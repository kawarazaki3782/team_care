class RemoveMicropostIdFromComments < ActiveRecord::Migration[6.1]
  def change
    remove_column :comments, :micropost_id, :integer
  end
end
