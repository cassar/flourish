class BankAccountService
  class << self
    def balance
      UpBank::AccountBalance.new.call
    end

    def balance_formatted
      Money.from_cents(balance).format
    end
  end
end
