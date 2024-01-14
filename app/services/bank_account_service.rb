class BankAccountService
  CENTS_IN_A_DOLLAR = 100

  class << self
    def balance
      UpBank::AccountBalance.new.call
    end

    def balance_formatted
      Money.from_amount(balance / CENTS_IN_A_DOLLAR).format
    end
  end
end
