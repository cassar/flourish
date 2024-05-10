class ContributionsParserService
  def call
    contributions.each do |contribution|
      NotificationMailer.with(contribution:).new_contribution_notification.deliver_now
    end
  end

  private

  def contributions
    parsed_transactions.filter_map do |parsed_transaction|
      next unless (contribution = Contribution.create(parsed_transaction)).persisted?

      contribution
    end
  end

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
