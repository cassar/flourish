class ChangeDividendStatusDefault < ActiveRecord::Migration[8.2]
  # Dividends are now either pending payout (1) or paid out (2); the old
  # default (0, "issued") no longer exists.
  def change
    change_column_default :dividends, :status, from: 0, to: 1
  end
end
