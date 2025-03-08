class TotalPayOutsCalculator
  class << self
    def formatted(currency)
      CurrencyConverter.new(
        from_currency: 'AUD',
        amount_in_base_units:,
        to_currency: currency
      ).format
    end

    private

    def amount_in_base_units
      in_aud_base_units total_paid_out_by_currency
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

    def total_paid_out_by_currency
      TotalPoolCalculationsService.total_paid_out_by_currency
    end
  end
end
