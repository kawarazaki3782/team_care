class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :gender
      t.date :birthday
      t.string :address
      t.text :profile
      t.string :profile_image
      t.string :long_teamcare

      t.timestamps
    end
  end
end
