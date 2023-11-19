class CreatePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.integer :status
      t.references :dividend, null: false, foreign_key: true

      t.timestamps
    end
  end
end
