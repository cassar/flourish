class BankAccountService
  class << self
    def balance
      UpBankAccount.new(
        access_token: ENV.fetch('up_bank_access_token', nil),
        account_number: ENV.fetch('up_bank_account_number', nil)
      ).balance
    rescue UpBankAccount::NoCredentialsError
      1000
    end

    def balance_formatted
      Money.from_amount(balance).format
    end
  end
end
