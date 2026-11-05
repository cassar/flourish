class TotalDividendsCalculator
  class << self
    def formatted(pod, currency)
      CurrencyConverter.format_from_aud(amount_in_base_units(pod), currency)
    end

    private

    def amount_in_base_units(pod)
      CurrencyConverter.in_aud_base_units total_dividends_by_currency(pod)
    end

    def total_dividends_by_currency(pod)
      TotalPodCalculations.total_dividends_by_currency(pod)
    end
  end
end
