class DistributionNameUnique < ActiveRecord::Migration[8.0]
  def change
    change_column_null :distributions, :name, false
    add_index :distributions, :name, unique: true
  end
end
