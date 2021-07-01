class AddStatusToDiaries < ActiveRecord::Migration[6.1]
  def change
    add_column :diaries, :status, :integer, default: 0, null: false
  end
end
