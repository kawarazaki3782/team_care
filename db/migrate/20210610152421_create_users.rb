class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.integer :gender
      t.date :birthday
      t.string :address
      t.text :profile
      t.binary :profile_image
      t.integer :long_teamcare

      t.timestamps
    end
  end
end
