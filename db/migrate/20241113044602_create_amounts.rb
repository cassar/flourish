class CreateAmounts < ActiveRecord::Migration[8.1]
  def change
    create_table :amounts do |t|
      t.references :distribution, null: false, foreign_key: true
      t.string :currency
      t.integer :amount_in_base_units

      t.timestamps
    end

    add_column :dividends, :amount, :bigint
  end
end
