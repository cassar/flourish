class OutstandingDividendsService
  def self.total_amount_in_base_units
    Distribution.joins(:dividends)
                .merge(Dividend.outstanding)
                .sum(:dividend_amount_in_base_units)
  end
end
