class ContributionsParserService
  def call
    parsed_transactions.each do |parsed_transaction|
      Contribution.create(parsed_transaction)
    end
  end

  private

  def parsed_transactions
    transactions.filter_map do |transaction|
      message = transaction.dig('attributes', 'message')
      next if message.nil?

      {
        up_bank_transaction_reference: transaction['id'],
        amount_in_base_units: transaction.dig('attributes', 'amount', 'valueInBaseUnits'),
        member_id: message[/\d+/]
      }
    end
  end

  def transactions
    UpBank::AccountTransactions.new.call
  end
end
