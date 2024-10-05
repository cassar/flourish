class RenameToHandle < ActiveRecord::Migration[8.0]
  def change
    rename_column :members, :paypalmeid, :paypalme_handle
  end
end
