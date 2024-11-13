class AddAmountForeignKey < ActiveRecord::Migration[8.1]
  def change
    add_foreign_key :dividends, :amounts
  end
end
