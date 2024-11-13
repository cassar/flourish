class RemoveDividendCurrency < ActiveRecord::Migration[8.1]
  def change
    remove_column :dividends, :currency, :string
    rename_column :dividends, :amount, :amount_id
  end
end
