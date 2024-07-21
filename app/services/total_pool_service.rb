class TotalPoolService
  class << self
    def balance_in_base_units
      bank_account_balance - outstanding_amount_in_base_units
    end

    def balance_formatted
      Money.from_cents(balance_in_base_units).format
    end

    private

    def bank_account_balance
      10_000
    end

    def outstanding_amount_in_base_units
      OutstandingDividendsService.total_amount_in_base_units
    end
  end
end
