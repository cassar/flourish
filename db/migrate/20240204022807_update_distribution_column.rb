class UpdateDistributionColumn < ActiveRecord::Migration[7.1]
  def change
    rename_column :distributions, :dividend_amount, :dividend_amount_in_base_units
  end
end
