class TotalPoolCalculationsService
  class << self
    def total_contributions_by_currency
      Contribution
        .group(:currency)
        .sum(:amount_in_base_units)
    end

    def total_owed_dividends_by_currency
      Amount.joins(:dividends)
            .merge(Dividend.owed)
            .group(:currency)
            .sum(:amount_in_base_units)
    end

    def total_paid_out_by_currency
      PayOut
        .group(:currency)
        .sum(:amount_in_base_units)
    end

    def total_recontributions_by_currency
      Amount.joins(:dividends)
            .merge(Dividend.recontributed)
            .group(:currency)
            .sum(:amount_in_base_units)
    end

    def total_dividends_by_currency
      Amount.joins(:dividends)
            .merge(Dividend.all)
            .group(:currency)
            .sum(:amount_in_base_units)
    end
  end
end
