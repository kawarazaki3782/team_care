class RemoveColumnsInCategories < ActiveRecord::Migration[6.1]
  def change
    remove_column :categories, :micropost_id
  end
end
