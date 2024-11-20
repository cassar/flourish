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
  end
end
