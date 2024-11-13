class AddAmountDefault < ActiveRecord::Migration[8.1]
  def change
    change_column_default :amounts, :currency, 'AUD'
  end
end
