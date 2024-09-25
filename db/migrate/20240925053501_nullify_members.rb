class NullifyMembers < ActiveRecord::Migration[7.2]
  def change
    change_column :contributions, :member_id, :bigint, null: true
  end
end
