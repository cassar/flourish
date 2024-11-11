class CreatePayOuts < ActiveRecord::Migration[8.1]
  def change
    create_table :pay_outs do |t|
      t.references :dividend, null: false, foreign_key: true

      t.integer :amount_in_source_currency_base_units, null: false
      t.integer :fees_in_source_currency_base_units, default: 0
      t.string :source_currency, default: 'AUD'

      t.integer :amount_in_target_currency_base_units, null: false
      t.string :target_currency, default: 'AUD'

      t.string :transaction_identifier, null: false

      t.timestamps
    end
  end
end
