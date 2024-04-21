class CreateContributions < ActiveRecord::Migration[7.1]
  def change
    create_table :contributions do |t|
      t.integer :amount_in_base_units
      t.references :member, null: false, foreign_key: true
      t.string :up_bank_transaction_reference

      t.timestamps
    end

    add_index :contributions, :up_bank_transaction_reference, unique: true
  end
end
