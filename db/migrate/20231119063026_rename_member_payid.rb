class RenameMemberPayid < ActiveRecord::Migration[7.1]
  def change
    rename_column :members, :pay_id, :payid
  end
end
