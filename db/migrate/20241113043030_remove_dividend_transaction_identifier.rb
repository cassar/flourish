class RemoveDividendTransactionIdentifier < ActiveRecord::Migration[8.1]
  def change
    remove_column :dividends, :transaction_identifier, :string
  end
end
