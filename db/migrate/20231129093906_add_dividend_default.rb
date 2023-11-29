class AddDividendDefault < ActiveRecord::Migration[7.1]
  def change
    change_column_default :dividends, :status, 0
  end
end
