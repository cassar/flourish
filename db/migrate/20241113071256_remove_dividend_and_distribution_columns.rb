class RemoveDividendAndDistributionColumns < ActiveRecord::Migration[8.1]
  def change
    remove_column :distributions, :dividend_amount_in_base_units, :int
    remove_column :dividends, :distribution_id, :bigint
    add_index :dividends, :amount_id
  end
end
