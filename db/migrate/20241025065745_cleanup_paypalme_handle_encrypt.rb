class CleanupPaypalmeHandleEncrypt < ActiveRecord::Migration[8.1]
  def change
    rename_column :members, :paypalme_handle, :paypalme_handle_old
    rename_column :members, :paypalme_handle_new, :paypalme_handle
  end
end
