class AddPostImageToMicroposts < ActiveRecord::Migration[6.1]
  def change
    add_column :microposts, :post_image, :string
  end
end
