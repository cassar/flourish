class AddCurrencyToContributions < ActiveRecord::Migration[8.1]
  def change
    add_column :contributions, :currency, :string, default: 'AUD'
  end
end
