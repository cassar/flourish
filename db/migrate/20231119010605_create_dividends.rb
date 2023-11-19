class CreateDividends < ActiveRecord::Migration[7.1]
  def change
    create_table :dividends do |t|
      t.integer :amount

      t.timestamps
    end
  end
end
