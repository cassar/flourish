# Preview all emails at http://localhost:3000/rails/mailers/dividend_mailer
class DividendMailerPreview < ActionMailer::Preview
  def new_dividend_notification
    user = User.new(email: 'email@example.com')
    member = Member.new(payid: 'my_pay_id', user:)
    distribution = Distribution.new(dividend_amount_in_base_units: 400)
    dividend = Dividend.new(id: 1, member:, distribution:)
    DividendMailer.with(dividend:).new_dividend_notification
  end

  def pay_out_notification
    user = User.new(email: 'email@example.com')
    member = Member.new(payid: 'my_pay_id', user:)
    dividend = Dividend.new(id: 1, member:)
    DividendMailer.with(dividend:).pay_out_notification
  end

  def paid_out_notification
    user = User.new(email: 'email@example.com')
    member = Member.new(payid: 'my_pay_id', user:)
    distribution = Distribution.new(dividend_amount_in_base_units: 400)
    dividend = Dividend.new(id: 1, member:, distribution:, receipt: '172receipt_no38a')
    DividendMailer.with(dividend:).paid_out_notification
  end
end
