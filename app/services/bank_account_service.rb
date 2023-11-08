class BankAccountService
  class << self
    def balance
      1000
    end

    def balance_formatted
      Money.from_amount(balance).format
    end
  end
end
