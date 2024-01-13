class RemoveMemberColumns < ActiveRecord::Migration[7.1]
  def change
    remove_column :members, :active
    remove_column :members, :contribution_amount
  end
end
