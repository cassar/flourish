class TotalPoolCalculations
  class << self
    def total_contributions_by_currency(pool)
      pool.contributions
        .group(:currency)
        .sum(:amount_in_base_units)
    end

    def total_owed_dividends_by_currency(pool)
      dividends_for(pool)
        .merge(Dividend.owed)
        .group(:currency)
        .sum(:amount_in_base_units)
    end

    def recontributions_by_currency(distribution)
      distribution.amounts
        .joins(:dividends)
        .merge(Dividend.recontributed)
        .group(:currency)
        .sum(:amount_in_base_units)
    end

    def total_paid_out_by_currency(pool)
      pay_outs_for(pool)
        .group(:currency)
        .sum(:amount_in_base_units)
    end

    def total_pay_out_fees_by_currency(pool)
      pay_outs_for(pool)
        .group(:currency)
        .sum(:fees_in_base_units)
    end

    def total_recontributions_by_currency(pool)
      dividends_for(pool)
        .merge(Dividend.recontributed)
        .group(:currency)
        .sum(:amount_in_base_units)
    end

    def total_dividends_by_currency(pool)
      dividends_for(pool)
        .group(:currency)
        .sum(:amount_in_base_units)
    end

    private

    def dividends_for(pool)
      Amount.joins(:dividends, :distribution)
        .where(distributions: { pool_id: pool.id })
    end

    def pay_outs_for(pool)
      PayOut.joins(dividend: { amount: :distribution })
        .where(distributions: { pool_id: pool.id })
    end
  end
end
