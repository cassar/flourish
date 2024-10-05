class RenameReceipt < ActiveRecord::Migration[8.0]
  def change
    rename_column :dividends, :receipt, :transaction_identifier
    change_column :dividends, :transaction_identifier, :string
  end
end
