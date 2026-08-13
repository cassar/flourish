class TotalContributedAndRecontributedCalculator
  class << self
    def formatted(pod, currency)
      CurrencyConverter.new(
        from_currency: 'AUD',
        amount_in_base_units: amount_in_base_units(pod),
        to_currency: currency
      ).format
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
      in_aud_base_units total_recontributions_by_currency(pod)
    end

    def in_aud_base_units(amount_in_base_units_by_currency)
      amount_in_base_units_by_currency.sum do |currency, amount_in_base_units|
        CurrencyConverter.new(
          from_currency: currency,
          amount_in_base_units:,
          to_currency: 'AUD'
        ).amount_in_base_units
      end
    end

    def total_recontributions_by_currency(pod)
      TotalPodCalculations.total_recontributions_by_currency(pod)
    end
  end
end
