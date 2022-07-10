class AddContribution < ActiveRecord::Migration[7.0]
  def change
    add_column :members, :contribution_amount, :integer
    change_column_default :members, :contribution_amount, from: nil, to: 0
  end
end
