# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview
  def contribution_received
    user = User.new(email: 'email@example.com')
    member = Member.new(user:)
    contribution = Contribution.new(amount_in_base_units: 500, transaction_identifier: 'teuharub239', member:)
    NotificationMailer.with(contribution:).contribution_received
  end

  def dividend_received
    user = User.new(email: 'email@example.com')
    member = Member.new(user:)
    amount = Amount.new(amount_in_base_units: 400)
    dividend = Dividend.new(id: 1, member:, amount:)
    NotificationMailer.with(dividend:).dividend_received
  end

  def dividend_paid_out
    user = User.new(email: 'email@example.com')
    member = Member.new(user:)
    amount = Amount.new(amount_in_base_units: 400)
    dividend = Dividend.new(id: 1, member:, amount:)
    pay_out = PayOut.new(dividend:, transaction_identifier: 'etthu_transaction_2324')
    NotificationMailer.with(pay_out:).dividend_paid_out
  end

  def dividend_automatically_recontributed
    user = User.new(email: 'email@example.com')
    member = Member.new(user:)
    amount = Amount.new(amount_in_base_units: 400)
    dividend = Dividend.new(id: 1, member:, amount:)
    NotificationMailer.with(dividend:).dividend_automatically_recontributed
  end

  def distribution_settled
    distribution = Distribution.new(number: 32)
    user = User.new(email: 'email@example.com')
    NotificationMailer.with(distribution:, user:).distribution_settled
  end

  def distribution_preview
    user = User.new(email: 'email@example.com')
    user.member = Member.new
    NotificationMailer.with(user:).distribution_preview
  end
end
