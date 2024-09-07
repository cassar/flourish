# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview
  def new_contribution
    user = User.new(email: 'email@example.com')
    member = Member.new(paypalmeid: 'my_paypalmeid', user:)
    contribution = Contribution.new(amount_in_base_units: 500, member:)
    NotificationMailer.with(contribution:).new_contribution
  end

  def new_dividend
    user = User.new(email: 'email@example.com')
    member = Member.new(paypalmeid: 'my_paypalmeid', user:)
    distribution = Distribution.new(dividend_amount_in_base_units: 400)
    dividend = Dividend.new(id: 1, member:, distribution:)
    NotificationMailer.with(dividend:).new_dividend
  end

  def paid_out
    user = User.new(email: 'email@example.com')
    member = Member.new(paypalmeid: 'my_paypalmeid', user:)
    distribution = Distribution.new(dividend_amount_in_base_units: 400)
    dividend = Dividend.new(id: 1, member:, distribution:, receipt: '172receipt_no38a')
    NotificationMailer.with(dividend:).paid_out
  end

  def dividend_recontributed
    user = User.new(email: 'email@example.com')
    member = Member.new(paypalmeid: 'my_paypalmeid', user:)
    distribution = Distribution.new(dividend_amount_in_base_units: 400)
    dividend = Dividend.new(id: 1, member:, distribution:, receipt: '172receipt_no38a')
    NotificationMailer.with(dividend:).dividend_recontributed
  end
end
