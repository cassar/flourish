class Expenses < ActiveRecord::Migration[8.0]
  def change
    create_table :expenses do |t|
      t.string :name
      t.integer :amount_in_base_units

      t.timestamps
    end
  end
end
