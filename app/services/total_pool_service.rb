class TotalPoolService
  class << self
    def balance_in_base_units
      total_contributed_in_base_units - total_owed_in_base_units - total_expense_in_base_units
    end

    def balance_formatted
      Money.new(balance_in_base_units, 'AUD').format
    end

    private

    def total_contributed_in_base_units
      Contribution.sum(:amount_in_base_units)
    end

    def total_owed_in_base_units
      Amount.joins(:dividends)
            .merge(Dividend.owed)
            .sum(:amount_in_base_units)
    end

    def total_expense_in_base_units
      Expense.sum(:amount_in_base_units)
    end
  end
end
