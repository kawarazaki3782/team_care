class CreateDiaries < ActiveRecord::Migration[6.1]
  def change
    create_table :diaries do |t|
      t.string :title
      t.text :content
      t.string :diary_image
      t.references :user, null: false, foreign_key: true
      t.integer :category_id
      
      t.timestamps
    end
    add_index :diaries, [:user_id, :created_at]
  end
end
