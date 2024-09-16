# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview
  def contribution_received
    user = User.new(email: 'email@example.com')
    member = Member.new(paypalmeid: 'my_paypalmeid', user:)
    contribution = Contribution.new(amount_in_base_units: 500, transaction_identifier: 'teuharub239', member:)
    NotificationMailer.with(contribution:).contribution_received
  end

  def dividend_received
    user = User.new(email: 'email@example.com')
    member = Member.new(paypalmeid: 'my_paypalmeid', user:)
    distribution = Distribution.new(dividend_amount_in_base_units: 400)
    dividend = Dividend.new(id: 1, member:, distribution:)
    NotificationMailer.with(dividend:).dividend_received
  end

  def dividend_paid_out
    user = User.new(email: 'email@example.com')
    member = Member.new(paypalmeid: 'my_paypalmeid', user:)
    distribution = Distribution.new(dividend_amount_in_base_units: 400)
    dividend = Dividend.new(id: 1, member:, distribution:, receipt: '172receipt_no38a')
    NotificationMailer.with(dividend:).dividend_paid_out
  end

  def dividend_automatically_recontributed
    user = User.new(email: 'email@example.com')
    member = Member.new(paypalmeid: 'my_paypalmeid', user:)
    distribution = Distribution.new(dividend_amount_in_base_units: 400)
    dividend = Dividend.new(id: 1, member:, distribution:, receipt: '172receipt_no38a')
    NotificationMailer.with(dividend:).dividend_automatically_recontributed
  end
end
