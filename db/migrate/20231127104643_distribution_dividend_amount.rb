class DistributionDividendAmount < ActiveRecord::Migration[7.1]
  def change
    rename_column :distributions, :amount_in_base_units, :dividend_amount
  end
end
