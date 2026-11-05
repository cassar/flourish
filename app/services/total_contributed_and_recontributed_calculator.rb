class TotalContributedAndRecontributedCalculator
  class << self
    def formatted(pod, currency)
      CurrencyConverter.format_from_aud(amount_in_base_units(pod), currency)
    end

    private

    def amount_in_base_units(pod)
      [
        total_contributed_in_aud_base_units(pod),
        total_recontributed_in_aud_base_units(pod)
      ].sum
    end

    def total_contributed_in_aud_base_units(pod)
      TotalContributionsCalculator.aud_base_units(pod)
    end

    def total_recontributed_in_aud_base_units(pod)
      CurrencyConverter.in_aud_base_units total_recontributions_by_currency(pod)
    end

    def total_recontributions_by_currency(pod)
      TotalPodCalculations.total_recontributions_by_currency(pod)
    end
  end
end
