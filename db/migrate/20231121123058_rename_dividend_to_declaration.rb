class RenameDividendToDeclaration < ActiveRecord::Migration[7.1]
  def change
    rename_table :dividends, :distributions
    rename_column :distributions, :amount, :amount_in_base_units

    rename_table :payments, :dividends
    rename_column :dividends, :dividend_id, :distribution_id
  end
end
