class Remove < ActiveRecord::Migration[8.1]
  def change
    remove_column :members, :paypalme_handle_old
  end
end
