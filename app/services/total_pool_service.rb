class TotalPoolService
  class << self
    def balance_in_base_units
      total_contributed_in_base_units - total_owed_in_base_units - total_expense_in_base_units
    end

    def balance_formatted
      Money.from_cents(balance_in_base_units).format
    end

    private

    def total_contributed_in_base_units
      Contribution.sum(:amount_in_base_units)
    end

    def total_owed_in_base_units
      Distribution.joins(:dividends)
                  .merge(Dividend.owed)
                  .sum(:dividend_amount_in_base_units)
    end

    def total_expense_in_base_units
      Expense.sum(:amount_in_base_units)
    end
  end
end
