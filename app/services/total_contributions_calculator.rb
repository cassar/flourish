class TotalContributionsCalculator
  class << self
    def aud_base_units(pool)
      in_aud_base_units total_contributions_by_currency(pool)
    end

    private

    def in_aud_base_units(amount_in_base_units_by_currency)
      amount_in_base_units_by_currency.sum do |currency, amount_in_base_units|
        CurrencyConverter.new(
          from_currency: currency,
          amount_in_base_units:,
          to_currency: 'AUD'
        ).amount_in_base_units
      end
    end

    def total_contributions_by_currency(pool)
      TotalPoolCalculations.total_contributions_by_currency(pool)
    end
  end
end
