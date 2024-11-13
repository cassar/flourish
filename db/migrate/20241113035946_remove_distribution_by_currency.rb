class RemoveDistributionByCurrency < ActiveRecord::Migration[8.1]
  def change
    remove_column :distributions, :dividends_by_currency_in_base_units, :jsonb
  end
end
