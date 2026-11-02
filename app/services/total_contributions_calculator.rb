class TotalContributionsCalculator
  class << self
    def aud_base_units(pod)
      CurrencyConverter.in_aud_base_units total_contributions_by_currency(pod)
    end

    private

    def total_contributions_by_currency(pod)
      TotalPodCalculations.total_contributions_by_currency(pod)
    end
  end
end
