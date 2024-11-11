class AddDividendCurrency < ActiveRecord::Migration[8.1]
  def change
    remove_column :pay_outs, :amount_in_target_currency_base_units
    remove_column :pay_outs, :target_currency
    
    rename_column :pay_outs, :amount_in_source_currency_base_units, :amount_in_base_units
    rename_column :pay_outs, :source_currency, :currency
    rename_column :pay_outs, :fees_in_source_currency_base_units, :fees_in_base_units

    add_column :dividends, :amount_in_base_units, :integer
    add_column :dividends, :currency, :string, default: 'AUD'
  end
end
