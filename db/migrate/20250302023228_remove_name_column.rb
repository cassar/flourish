class RemoveNameColumn < ActiveRecord::Migration[8.1]
  def change
    remove_column :distributions, :name, :string
    change_column_null :distributions, :number, false
    add_index :distributions, :number, unique: true
  end
end
