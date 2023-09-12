class AddActiveToMembers < ActiveRecord::Migration[7.0]
  def change
    add_column :members, :active, :integer, default: 0
  end
end
