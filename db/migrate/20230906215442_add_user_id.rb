class AddUserId < ActiveRecord::Migration[7.0]
  def change
    Member.destroy_all
    add_column :members, :user_id, :integer, null: false
    add_foreign_key :members, :users
    add_index :members, :user_id, unique: true
  end
end
