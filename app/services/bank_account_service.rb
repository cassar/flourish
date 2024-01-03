class BankAccountService
  class << self
    def balance
      UpBankAccount.new(
        access_token: ENV.fetch('UP_BANK_ACCESS_TOKEN', nil),
        account_number: ENV.fetch('UP_BANK_ACCOUNT_NUMBER', nil)
      ).balance
    rescue UpBankAccount::NoCredentialsError
      1000
    end

    def balance_formatted
      Money.from_amount(balance).format
    end
  end
end
