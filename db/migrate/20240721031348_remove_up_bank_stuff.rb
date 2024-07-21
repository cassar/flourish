class RemoveUpBankStuff < ActiveRecord::Migration[7.2]
  def change
    remove_column :contributions, :up_bank_transaction_reference
  end
end
