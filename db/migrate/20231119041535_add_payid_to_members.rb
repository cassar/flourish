class AddPayidToMembers < ActiveRecord::Migration[7.1]
  def change
    add_column :members, :pay_id, :string
  end
end
