class TotalPodCalculations
  class << self
    def total_contributions_by_currency(pod)
      pod.contributions
        .group(:currency)
        .sum(:amount_in_base_units)
    end

    def total_owed_dividends_by_currency(pod)
      dividends_for(pod)
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

    def total_paid_out_by_currency(pod)
      pay_outs_for(pod)
        .group(:currency)
        .sum(:amount_in_base_units)
    end

    def total_pay_out_fees_by_currency(pod)
      pay_outs_for(pod)
        .group(:currency)
        .sum(:fees_in_base_units)
    end

    def total_recontributions_by_currency(pod)
      dividends_for(pod)
        .merge(Dividend.recontributed)
        .group(:currency)
        .sum(:amount_in_base_units)
    end

    def total_dividends_by_currency(pod)
      dividends_for(pod)
        .group(:currency)
        .sum(:amount_in_base_units)
    end

    private

    def dividends_for(pod)
      Amount.joins(:dividends, :distribution)
        .where(distributions: { pod_id: pod.id })
    end

    def pay_outs_for(pod)
      PayOut.joins(dividend: { amount: :distribution })
        .where(distributions: { pod_id: pod.id })
    end
  end
end
