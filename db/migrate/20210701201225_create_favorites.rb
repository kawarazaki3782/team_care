class CreateFavorites < ActiveRecord::Migration[6.1]
  def change
    create_table :favorites do |t|
        t.references :user, null:false
        t.references :micropost
        t.references :diary

      t.timestamps
    end
  end
end
