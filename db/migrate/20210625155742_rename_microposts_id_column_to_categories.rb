class RenameMicropostsIdColumnToCategories < ActiveRecord::Migration[6.1]
  def change
    rename_column :categories, :microposts_id, :micropost_id
  end
end
