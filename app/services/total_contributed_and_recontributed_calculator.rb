class TotalContributedAndRecontributedCalculator
  class << self
    def formatted(pool, currency)
      CurrencyConverter.new(
        from_currency: 'AUD',
        amount_in_base_units: amount_in_base_units(pool),
        to_currency: currency
      ).format
    end

    private

    def amount_in_base_units(pool)
      [
        total_contributed_in_aud_base_units(pool),
        total_recontributed_in_aud_base_units(pool)
      ].sum
    end

    def total_contributed_in_aud_base_units(pool)
      TotalContributionsCalculator.aud_base_units(pool)
    end

    def total_recontributed_in_aud_base_units(pool)
      in_aud_base_units total_recontributions_by_currency(pool)
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

    def total_recontributions_by_currency(pool)
      TotalPoolCalculations.total_recontributions_by_currency(pool)
    end
  end
end
