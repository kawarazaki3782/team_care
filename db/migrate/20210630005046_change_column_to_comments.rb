class ChangeColumnToComments < ActiveRecord::Migration[6.1]
  def change
    add_reference :comments, :micropost, foreign_key: true
    add_reference :comments, :diary, foreign_key: true
  end
end
