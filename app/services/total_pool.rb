class TotalPool
  class << self
    def balance_in_aud_base_units
      Integer(total_assets_in_aud_base_units - total_liabilites_in_aud_base_units)
    end

    def balance_formatted(currency)
      CurrencyConverter.new(
        from_currency: 'AUD',
        amount_in_base_units: balance_in_aud_base_units,
        to_currency: currency
      ).format
    end

    def total_contributed_and_recontributed_formatted(currency)
      TotalContributedAndRecontributedCalculator.formatted(currency)
    end

    def total_paid_out_formatted(currency)
      TotalPayOutsCalculator.formatted(currency)
    end

    def total_dividends_formatted(currency)
      TotalDividendsCalculator.formatted(currency)
    end

    private

    def total_assets_in_aud_base_units
      total_contributed_in_aud_base_units
    end

    def total_liabilites_in_aud_base_units
      [
        total_owed_dividends_in_aud_base_units,
        total_paid_out_in_aud_base_units,
        total_pay_out_fees_in_aud_base_units,
        total_expense_in_aud_base_units
      ].sum
    end

    def total_contributed_in_aud_base_units
      TotalContributionsCalculator.aud_base_units
    end

    def total_owed_dividends_in_aud_base_units
      in_aud_base_units total_owed_dividends_by_currency
    end

    def total_paid_out_in_aud_base_units
      in_aud_base_units total_paid_out_by_currency
    end

    def total_pay_out_fees_in_aud_base_units
      in_aud_base_units total_pay_out_fees_by_currency
    end

    def total_expense_in_aud_base_units
      Expense.sum(:amount_in_base_units)
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

    def total_owed_dividends_by_currency
      TotalPoolCalculations.total_owed_dividends_by_currency
    end

    def total_paid_out_by_currency
      TotalPoolCalculations.total_paid_out_by_currency
    end

    def total_pay_out_fees_by_currency
      TotalPoolCalculations.total_pay_out_fees_by_currency
    end
  end
end
