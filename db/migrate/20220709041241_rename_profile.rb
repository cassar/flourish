class RenameProfile < ActiveRecord::Migration[7.0]
  def change
    rename_table :profiles, :members
  end
end
