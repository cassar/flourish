class TotalPoolService
  class << self
    def balance_in_base_units
      Integer(total_assets_in_base_units - total_liabilites_in_base_units)
    end

    def balance_formatted(currency)
      Money.new(balance_in_base_units, 'AUD').exchange_to(currency).format
    end

    private

    def total_assets_in_base_units
      total_contributed_in_base_units
    end

    def total_liabilites_in_base_units
      [
        total_owed_in_base_units,
        total_paid_out_in_base_units,
        total_expense_in_base_units
      ].sum
    end

    def total_contributed_in_base_units
      in_aud_base_units total_contributions_by_currency
    end

    def total_owed_in_base_units
      in_aud_base_units total_owed_dividends_by_currency
    end

    def total_paid_out_in_base_units
      in_aud_base_units total_paid_out_by_currency
    end

    def total_expense_in_base_units
      Expense.sum(:amount_in_base_units)
    end

    def in_aud_base_units(amount_in_base_units_by_currency)
      amount_in_base_units_by_currency.sum do |currency, amount_in_base_units|
        Money.new(amount_in_base_units, currency).exchange_to('AUD').fractional
      end
    end

    def total_contributions_by_currency
      TotalPoolCalculationsService.total_contributions_by_currency
    end

    def total_owed_dividends_by_currency
      TotalPoolCalculationsService.total_owed_dividends_by_currency
    end

    def total_paid_out_by_currency
      TotalPoolCalculationsService.total_paid_out_by_currency
    end
  end
end
