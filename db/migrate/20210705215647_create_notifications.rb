class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.integer :visiter_id
      t.integer :visited_id
      t.integer :diary_id
      t.integer :comment_id
      t.string :action
      t.boolean :checked, default: false, null: false
      t.integer :micropost_id

      t.timestamps
    end
  end
end
