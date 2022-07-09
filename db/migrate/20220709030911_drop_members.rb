class DropMembers < ActiveRecord::Migration[7.0]
  def change
    drop_table :members
  end
end
