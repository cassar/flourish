class CloseHistoricalDistributions < ActiveRecord::Migration[8.2]
  # Dividend statuses at the time of writing.
  ISSUED = 0
  PAY_OUT_COMPLETE = 2
  MANUALLY_RECONTRIBUTED = 3
  AUTO_RECONTRIBUTED = 4

  # Closes every existing distribution: its amount becomes what was actually paid
  # out (excluding fees), and dividends that were never paid out (unclaimed or
  # recontributed) are deleted. Recontributed money never left the pod, so pod
  # balances are unchanged. Distributions with no payouts are kept at 0.
  def up
    execute <<~SQL.squish
      UPDATE distributions SET amount_in_base_units = COALESCE((
        SELECT SUM(pay_outs.amount_in_base_units)
        FROM pay_outs
        JOIN dividends ON dividends.id = pay_outs.dividend_id
        JOIN amounts ON amounts.id = dividends.amount_id
        WHERE amounts.distribution_id = distributions.id
          AND dividends.status = #{PAY_OUT_COMPLETE}
      ), 0)
    SQL

    execute <<~SQL.squish
      DELETE FROM dividends
      WHERE status IN (#{ISSUED}, #{MANUALLY_RECONTRIBUTED}, #{AUTO_RECONTRIBUTED})
    SQL
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
