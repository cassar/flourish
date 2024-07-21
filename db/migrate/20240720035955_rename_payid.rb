class RenamePayid < ActiveRecord::Migration[7.2]
  def change
    rename_column :members, :payid, :paypalmeid
  end
end
