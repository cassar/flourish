class AddReceiptToDividend < ActiveRecord::Migration[7.1]
  def change
    add_column :dividends, :receipt, :text
  end
end
