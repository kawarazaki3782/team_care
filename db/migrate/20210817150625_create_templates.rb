class CreateTemplates < ActiveRecord::Migration[6.1]
  def change
    create_table :templates do |t|
      t.integer :user_id, null: false
      t.text :content
      t.timestamps
    end
  end
end
