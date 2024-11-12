class AddCurrencyDistribution < ActiveRecord::Migration[8.1]
  def change
    add_column :distributions, :dividends_by_currency_in_base_units, :jsonb

    remove_column :dividends, :amount_in_base_units
  end
end
